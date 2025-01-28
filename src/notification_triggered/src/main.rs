use lambda_runtime::{run, service_fn, tracing, Error, LambdaEvent};
use octocrab::Octocrab;
use shared::functions::get_username_map;
use shared::types::{AsyncLambdaPayload, KudosIssue, Res};
use sqlx::PgPool;
use sqlx::Row;
use std::env;

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

    let repo_id_rows = sqlx::query("SELECT id, project_id FROM repositories WHERE url = $1") // make url unique
        .bind(&repo_url)
        .fetch_all(&mut *tx)
        .await?;

    let username_to_id = get_username_map(&mut tx).await?;

    let assignee_user_id = if let Some(assignee) = &kudos_issue.assignee_username {
        if let Some(user_id) = username_to_id.get(assignee) {
            Some(*user_id)
        } else {
            let new_user_row = sqlx::query(
                "INSERT INTO users (username, avatar, github_id) VALUES ($1, $2, $3) ON CONFLICT (github_id) DO UPDATE SET username = EXCLUDED.username RETURNING id",
            )
            .bind(&kudos_issue.assignee_username)
            .bind(&kudos_issue.assignee_avatar_url)
            .bind(&kudos_issue.assignee_github_id)
            .fetch_one(&mut *tx)
            .await?;
            let new_user_id: i32 = new_user_row.get("id");
            Some(new_user_id)
        }
    } else {
        None
    };

    for repo_id_row in repo_id_rows {
        let repo_id: i32 = repo_id_row.get("id");

        sqlx::query(
        r#"
        INSERT INTO tasks (number, title, labels, repository_id, issue_created_at, issue_closed_at, assignee_user_id, open, description, type, status)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 'dev', $10)
        ON CONFLICT (repository_id, number)
        DO UPDATE SET
            title = EXCLUDED.title,
            labels = EXCLUDED.labels,
            issue_created_at = EXCLUDED.issue_created_at,
            issue_closed_at = EXCLUDED.issue_closed_at,
            assignee_user_id = EXCLUDED.assignee_user_id,
            open = EXCLUDED.open,
            description = EXCLUDED.description,
            status = EXCLUDED.status
        "#
        )
        .bind(&kudos_issue.number)
        .bind(&kudos_issue.title)
        .bind(&kudos_issue.labels)
        .bind(repo_id)
        .bind(&kudos_issue.issue_created_at)
        .bind(&kudos_issue.issue_closed_at)
        .bind(assignee_user_id)
        .bind(&kudos_issue.issue_closed_at.is_none())
        .bind(&kudos_issue.description)
        .bind(match (&kudos_issue.issue_closed_at, &kudos_issue.assignee_username) {
            (None, None) => "open",
            (None, Some(_)) => "in-progress",
            (Some(_), _) => "completed",
        })
        .execute(&mut *tx).await?;
    }

    sqlx::query(
        r#"
        UPDATE tasks
        SET is_certified = true
        WHERE (is_certified = false OR is_certified IS NULL) AND 'kudos' = ANY(labels)
        "#,
    )
    .execute(&mut *tx)
    .await?;

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
