use crate::types::{KudosIssue, Project, RepoInfo, Repository};

use lambda_http::{tracing::error, Body, Error, Request};
use octocrab::{params::State, Octocrab};
use sqlx::{Pool, Postgres, Row};
use std::env;

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

pub async fn insert_project(project: &Project, pool: &Pool<Postgres>) -> Result<i32, Error> {
    let query = project.new_project_query();

    let project_row = sqlx::query(query)
        .bind(&project.name)
        .bind(&project.slug)
        .bind(&project.attributes.types)
        .bind(&project.attributes.purposes)
        .bind(&project.attributes.stack_levels)
        .bind(&project.attributes.technologies)
        .fetch_one(pool)
        .await?;

    let project_id: i32 = project_row.get("id");

    Ok(project_id)
}

pub async fn import_repositories(
    repos_to_import: &Vec<Repository>,
    project_id: i32,
    pool: &Pool<Postgres>,
) -> Result<u64, Error> {
    let token = env::var("GITHUB_TOKEN")?;
    let octocrab = Octocrab::builder().personal_token(token).build()?;
    let mut total_issues_imported = 0;

    for repo in repos_to_import.iter() {
        let repo_info = RepoInfo::from_url(&repo.url)
            .ok_or_else(|| Error::from("Couldn't extract repo info from url"))?;

        let repo_query = repo.insert_respository_query();

        let repo_row = sqlx::query(repo_query)
            .bind(&repo.label)
            .bind(project_id)
            .bind(format!(
                "https://github.com/{}/{}",
                &repo_info.owner, &repo_info.name
            ))
            .fetch_one(pool)
            .await?;

        let repo_id: i32 = repo_row.get("id");

        let page = octocrab
            .issues(repo_info.owner, repo_info.name)
            .list()
            .state(State::Open)
            .per_page(100)
            .send()
            .await?;

        let filtered_issues: Vec<KudosIssue> = page
            .items
            .into_iter()
            .filter_map(|issue| {
                issue
                    .pull_request
                    .is_none()
                    .then(|| KudosIssue::from(issue))
            })
            .collect();

        if filtered_issues.is_empty() {
            continue;
        }

        let placeholders = filtered_issues
            .iter()
            .enumerate()
            .map(|(i, _)| {
                format!(
                    "(${}, ${}, ${}, ${}, ${})",
                    i * 5 + 1,
                    i * 5 + 2,
                    i * 5 + 3,
                    i * 5 + 4,
                    i * 5 + 5
                )
            })
            .collect::<Vec<_>>()
            .join(", ");

        let query_string = format!(
            "INSERT INTO issues (number, title, labels, repository_id, issue_created_at) VALUES {}",
            placeholders
        );

        let mut insert_issues_query = sqlx::query(&query_string);

        for issue in filtered_issues {
            insert_issues_query = insert_issues_query
                .bind(issue.number)
                .bind(issue.title)
                .bind(issue.labels)
                .bind(repo_id)
                .bind(issue.issue_created_at)
        }

        let issues_inserted_count = insert_issues_query.execute(pool).await?.rows_affected();

        total_issues_imported += issues_inserted_count;
    }
    Ok(total_issues_imported)
}
