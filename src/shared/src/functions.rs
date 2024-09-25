use crate::types::{ImportType, KudosIssue, Project, RepoInfo, Repository};

use lambda_http::{
    tracing::{error, info},
    Body, Error, Request,
};
use octocrab::{params::State, Octocrab};
use sqlx::{Postgres, Row, Transaction};
use std::{collections::HashMap, env};

use futures_util::TryStreamExt;
use tokio::pin;

pub fn extract_project(event: Request) -> Result<Project, Error> {
    let request_body = event.body();
    let json_string = (match request_body {
        Body::Text(json) => Some(json),
        _ => None,
    })
    .ok_or_else(|| Error::from("Invalid request body type"))?;

    let project: Project = serde_json::from_str(&json_string).map_err(|e| {
        error!("Error parsing JSON: {}", e);
        Error::from("Error parsing JSON")
    })?;

    Ok(project)
}

pub async fn insert_project(
    project: &Project,
    tx: &mut Transaction<'_, Postgres>,
) -> Result<i32, Error> {
    let query = project.new_project_query();

    let project_row = sqlx::query(query)
        .bind(&project.name)
        .bind(&project.slug)
        .bind(&project.attributes.types)
        .bind(&project.attributes.purposes)
        .bind(&project.attributes.stack_levels)
        .bind(&project.attributes.technologies)
        .fetch_one(&mut **tx)
        .await?;

    let project_id: i32 = project_row.get("id");

    Ok(project_id)
}

pub async fn import_repositories(
    import_type: ImportType,
    repos_to_import: &Vec<Repository>,
    project_id: i32,
    tx: &mut Transaction<'_, Postgres>,
) -> Result<u64, Error> {
    let token = env::var("GITHUB_TOKEN")?;
    let octocrab = Octocrab::builder().personal_token(token).build()?;
    let mut total_issues_imported = 0;

    for (i, repo) in repos_to_import.iter().enumerate() {
        let repo_info = RepoInfo::from_url(&repo.url)
            .ok_or_else(|| Error::from("Couldn't extract repo info from url"))?;

        let repo_data = octocrab
            .repos(&repo_info.owner, &repo_info.name)
            .get()
            .await?;

        let avatar_url = repo_data
            .owner
            .and_then(|owner| Some(owner.avatar_url.to_string()));

        if i == 0 && matches!(import_type, ImportType::Import) {
            sqlx::query("UPDATE projects SET avatar = $1 WHERE id = $2")
                .bind(avatar_url)
                .bind(project_id)
                .execute(&mut **tx)
                .await?;
        }

        let language = repo_data
            .language
            .ok_or_else(|| Error::from("No repo language"))?
            .as_str()
            .ok_or_else(|| Error::from("Can't get language as string"))?
            .to_string()
            .to_lowercase();

        let repo_query = repo.insert_respository_query();

        let repo_row = sqlx::query(repo_query)
            .bind(&repo.label)
            .bind(&repo_info.name)
            .bind(format!(
                "https://github.com/{}/{}",
                &repo_info.owner, &repo_info.name
            ))
            .bind(&language)
            .bind(project_id)
            .fetch_one(&mut **tx)
            .await?;

        let repo_id: i32 = repo_row.get("id");

        let stream = octocrab
            .issues(repo_info.owner, repo_info.name)
            .list()
            .state(State::Open)
            .per_page(100)
            .send()
            .await?
            .into_stream(&octocrab);
        pin!(stream);

        let filtered_issues: Vec<KudosIssue> = stream
            .try_filter_map(|issue| async move {
                Ok(issue
                    .pull_request
                    .is_none()
                    .then(|| KudosIssue::from(issue)))
            })
            .try_collect()
            .await?;

        info!("Number of open issues: {}", filtered_issues.len());
        if filtered_issues.is_empty() {
            continue;
        }

        let placeholders = filtered_issues
            .iter()
            .enumerate()
            .map(|(i, _)| {
                format!(
                    "(${}, ${}, ${}, ${}, ${}, ${}, ${}, ${})",
                    i * 8 + 1,
                    i * 8 + 2,
                    i * 8 + 3,
                    i * 8 + 4,
                    i * 8 + 5,
                    i * 8 + 6,
                    i * 8 + 7,
                    i * 8 + 8,
                )
            })
            .collect::<Vec<_>>()
            .join(", ");

        let query_string = format!(
            "INSERT INTO issues (number, title, labels, repository_id, issue_created_at, issue_closed_at, assignee_id, certified) VALUES {}",
            placeholders
        );

        let username_to_id = get_username_map(tx).await?;

        let mut insert_issues_query = sqlx::query(&query_string);

        for issue in filtered_issues {
            insert_issues_query = insert_issues_query
                .bind(issue.number)
                .bind(issue.title)
                .bind(issue.labels)
                .bind(repo_id)
                .bind(issue.issue_created_at)
                .bind(issue.issue_closed_at)
                .bind(if let Some(assignee) = issue.assignee {
                    username_to_id.get(&assignee)
                } else {
                    None
                })
                .bind(issue.certified)
        }

        let issues_inserted_count = insert_issues_query
            .execute(&mut **tx)
            .await?
            .rows_affected();

        total_issues_imported += issues_inserted_count;
    }
    Ok(total_issues_imported)
}

pub async fn get_username_map(
    tx: &mut Transaction<'_, Postgres>,
) -> Result<HashMap<String, i32>, Error> {
    let user_rows = sqlx::query("SELECT id, username FROM users")
        .fetch_all(&mut **tx)
        .await?;

    let mut username_to_id: HashMap<String, i32> = HashMap::new();

    for row in user_rows {
        username_to_id.insert(row.get("username"), row.get("id"));
    }
    Ok(username_to_id)
}
