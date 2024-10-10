use lambda_http::{
    run, service_fn,
    tracing::{self, error},
    Body, Error, Request, Response,
};
use serde_json;
use shared::{
    functions::import_repositories,
    types::{ImportType, Payload},
};
use sqlx::postgres::PgPool;
use sqlx::Row;
use std::env;

async fn function_handler(event: Request) -> Result<Response<Body>, Error> {
    let request_body = event.body();
    let json_string = (match request_body {
        Body::Text(json) => Some(json),
        _ => None,
    })
    .ok_or_else(|| Error::from("Invalid request body type"))?;

    let payload: Payload = serde_json::from_str(&json_string).map_err(|e| {
        error!("Error parsing JSON: {}", e);
        Error::from("Error parsing payload JSON")
    })?;

    let pool = PgPool::connect(&env::var("DATABASE_URL")?).await?;
    let mut tx: sqlx::Transaction<'_, sqlx::Postgres> = pool.begin().await?;

    // get project id - need to ensure that name and slug are unique!
    let project_row = sqlx::query("SELECT id FROM projects WHERE name = $1 AND slug = $2")
        .bind(payload.project_name)
        .bind(payload.project_slug)
        .fetch_one(&mut *tx)
        .await?;

    let project_id: i32 = project_row.get("id");

    if let Some(attributes) = payload.attributes {
        sqlx::query("UPDATE projects SET purposes = $1, stack_levels = $2, technologies = $3, types = $4 WHERE id = $5")
        .bind(attributes.purposes)
        .bind(attributes.stack_levels)
        .bind(attributes.technologies)
        .bind(attributes.types)
        .bind(project_id)
        .execute(&mut *tx).await?;
    }

    for repo in payload.repos_to_remove {
        // potentially refactor to use a single delete statment
        // This should automatically cascade to issues table
        sqlx::query("DELETE FROM repositories WHERE url = $1")
            .bind(repo.url)
            .execute(&mut *tx)
            .await?;
    }

    if payload.repos_to_add.is_empty() {
        tx.commit().await?;
        // return early
        return Ok(Response::builder()
            .status(200)
            .header("content-type", "text/plain")
            .body(Body::Text(format!("No repos to add")))
            .map_err(Box::new)?);
    }

    let total_issues_imported =
        import_repositories(ImportType::Sync, &payload.repos_to_add, project_id, &mut tx).await?;

    tx.commit().await?;

    let resp = Response::builder()
        .status(200)
        .header("content-type", "text/plain")
        .body(Body::Text(format!(
            "Total issues imported: {}",
            total_issues_imported
        )))
        .map_err(Box::new)?;
    Ok(resp)
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    tracing::init_default_subscriber();

    run(service_fn(function_handler)).await
}
