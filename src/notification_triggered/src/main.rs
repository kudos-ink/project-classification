use lambda_runtime::{run, service_fn, tracing, Error, LambdaEvent};
use octocrab::Octocrab;
use shared::functions::get_username_map;
use shared::types::{AsyncLambdaPayload, KudosIssue, Res};
use sqlx::PgPool;
use sqlx::Row;
use std::env;
use std::fmt::format;

/*
Receives issue details as payload
Fetches the latest version of that record from GitHub
Inserts it into the database
*/

async fn function_handler(event: LambdaEvent<AsyncLambdaPayload>) -> Result<Res, Error> {
    let issue_details = event.payload.response_payload;

    let pool = PgPool::connect(&env::var("DATABASE_URL")?).await?;
    let mut tx: sqlx::Transaction<'_, sqlx::Postgres> = pool.begin().await?;

    let token = env::var("GITHUB_TOKEN")?;
    let octocrab = Octocrab::builder().personal_token(token).build()?;
    let issue = octocrab
        .issues(&issue_details.owner, &issue_details.repo)
        .get(issue_details.issue_number)
        .await?;

    let kudos_issue = KudosIssue::from(issue);

    let repo_url = format!(
        "https://github.com/{}/{}",
        &issue_details.owner, &issue_details.repo
    );

    let repo_id_rows = sqlx::query("SELECT id FROM repositories WHERE url = $1") // make url unique
        .bind(&repo_url)
        .fetch_all(&mut *tx)
        .await?;

    for repo_id_row in repo_id_rows {
        let repo_id: i32 = repo_id_row.get("id");

        let username_to_id = get_username_map(&mut tx).await?;

        sqlx::query(
        r#"
        INSERT INTO issues (number, title, labels, repository_id, issue_created_at, issue_closed_at, assignee_id, open, certified, description)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
        ON CONFLICT (repository_id, number)
        DO UPDATE SET
            title = EXCLUDED.title,
            labels = EXCLUDED.labels,
            repository_id = EXCLUDED.repository_id,
            issue_created_at = EXCLUDED.issue_created_at,
            issue_closed_at = EXCLUDED.issue_closed_at,
            assignee_id = EXCLUDED.assignee_id,
            open = EXCLUDED.open,
            certified = EXCLUDED.certified,
            description = EXCLUDED.description
        "#
        )
        .bind(&kudos_issue.number)
        .bind(&kudos_issue.title)
        .bind(&kudos_issue.labels)
        .bind(repo_id)
        .bind(&kudos_issue.issue_created_at)
        .bind(&kudos_issue.issue_closed_at)
        .bind(if let Some(assignee) = &kudos_issue.assignee {
                        username_to_id.get(assignee)
                    } else {
                        None
                    })
        .bind(&kudos_issue.issue_closed_at.is_none())
        .bind(&kudos_issue.certified)
        .bind(&kudos_issue.description)
        .execute(&mut *tx).await?;
    }

    tx.commit().await?;

    Ok(Res {
        message: "Insert/Update successful".to_string(),
    })
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    tracing::init_default_subscriber();

    run(service_fn(function_handler)).await
}
