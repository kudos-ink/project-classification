use lambda_http::{run, service_fn, tracing, Body, Error, Request, Response};
use shared::{
    functions::{extract_project, import_repositories, insert_project},
    types::ImportType,
};
use sqlx::postgres::PgPool;
use std::env;

async fn function_handler(event: Request) -> Result<Response<Body>, Error> {
    let project = extract_project(event)?;
    let pool = PgPool::connect(&env::var("DATABASE_URL")?).await?;

    let mut tx: sqlx::Transaction<'_, sqlx::Postgres> = pool.begin().await?;

    // allow the import to be completely rerun by removing all data
    sqlx::query("DELETE FROM projects WHERE slug = $1")
        .bind(&project.slug)
        .execute(&mut *tx)
        .await?;

    let project_id = insert_project(&project, &mut tx).await?;

    let total_issues_imported = import_repositories(
        ImportType::Import,
        &project.links.repository,
        project_id,
        &mut tx,
    )
    .await?;

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
