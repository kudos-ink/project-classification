use chrono::{DateTime, Utc};
use octocrab::models::issues::Issue;
use serde::{Deserialize, Serialize};

#[derive(Deserialize, Debug)]
pub struct RepoInfo {
    pub owner: String,
    pub name: String,
}

impl RepoInfo {
    pub fn from_url(url: &str) -> Option<Self> {
        let parts: Vec<&str> = url.trim_end_matches('/').split('/').collect();
        if parts.len() >= 2 {
            Some(RepoInfo {
                owner: parts[parts.len() - 2].to_string(),
                name: parts[parts.len() - 1].to_string(),
            })
        } else {
            None
        }
    }
}

#[derive(Debug, Deserialize, Serialize)]
pub struct KudosIssue {
    pub number: i64,
    pub title: String,
    pub html_url: String,
    pub issue_created_at: DateTime<Utc>,
    // pub issue_updated_at: DateTime<Utc>,
    pub issue_closed_at: Option<DateTime<Utc>>,
    pub creator: String,
    pub assignee: Option<String>,
    // pub certified: bool,
    pub labels: Vec<String>,
    pub description: Option<String>,
}

impl From<Issue> for KudosIssue {
    fn from(value: Issue) -> Self {
        let labels = value
            .labels
            .iter()
            .map(|label| label.name.clone())
            .collect::<Vec<String>>();

        KudosIssue {
            number: value.number as i64,
            title: value.title,
            html_url: value.html_url.to_string(),
            issue_created_at: value.created_at,
            // issue_updated_at: value.updated_at,
            issue_closed_at: value.closed_at,
            creator: value.user.login,
            assignee: value.assignee.map(|assignee| assignee.login),
            // certified: labels.contains(&String::from("kudos")),
            labels,
            description: value.body,
        }
    }
}

#[derive(Deserialize, Debug)]
pub struct Repository {
    pub label: String,
    pub url: String,
}

impl Repository {
    pub fn insert_respository_query(&self) -> &str {
        let query_string = r#"
        INSERT INTO repositories (slug, name, url, language_slug, project_id)
        VALUES ($1, $2, $3, $4, $5)
        ON CONFLICT (url, slug, project_id)
        DO UPDATE SET
            name = EXCLUDED.name,
            language_slug = EXCLUDED.language_slug
        RETURNING id;
        "#;
        query_string
    }
}

#[derive(Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct ProjectAttributes {
    pub purposes: Vec<String>,
    pub stack_levels: Vec<String>,
    pub technologies: Vec<String>,
    pub types: Vec<String>,
    pub rewards: Option<bool>,
}

#[derive(Deserialize, Debug)]
pub struct Payload {
    pub project_slug: String,
    pub project_name: String,
    pub repos_to_add: Vec<Repository>,
    pub repos_to_remove: Vec<Repository>,
    pub attributes: Option<ProjectAttributes>,
}

#[derive(Deserialize, Debug)]
pub struct Project {
    pub name: String,
    pub slug: String,
    pub attributes: ProjectAttributes,
    pub links: ProjectLinks,
}
impl Project {
    pub fn new_project_query(&self) -> &str {
        let query_string = r#"
        INSERT INTO projects (name, slug, types, purposes, stack_levels, technologies, rewards)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        ON CONFLICT (slug)
        DO UPDATE SET
            name = EXCLUDED.name,
            types = EXCLUDED.types,
            purposes = EXCLUDED.purposes,
            stack_levels = EXCLUDED.stack_levels,
            technologies = EXCLUDED.technologies,
            rewards = EXCLUDED.rewards
        RETURNING id;
        "#;
        query_string
    }
}

#[derive(Deserialize, Debug)]
pub struct ProjectLinks {
    pub repository: Vec<Repository>,
}

#[derive(Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct AsyncLambdaPayload {
    pub response_payload: KudosIssuePayload,
}

#[derive(Deserialize, Debug)]
pub struct KudosIssuePayload {
    pub owner: String,
    pub repo: String,
    pub issue_number: u64,
}

pub enum ImportType {
    Import,
    Sync,
}
#[derive(Serialize, Debug)]
pub struct Res {
    pub message: String,
}
