use diesel::prelude::*;
use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};
use crate::schema::pages;

#[derive(Serialize, Deserialize)]
pub struct Page {
    pub id: i32,
    pub title: String,
    pub content: String,
    pub created_at: DateTime<Utc>,
}

#[derive(Queryable)]
#[diesel(table_name = pages)]
pub struct DbPage {
    pub id: i32,
    pub title: String,
    pub content: String,
    pub created_at: DateTime<Utc>,
}

#[derive(Insertable)]
#[diesel(table_name = pages)]
pub struct NewPage<'a> {
    pub title: &'a str,
    pub content: &'a str,
}

impl From<DbPage> for Page {
    fn from(db_page: DbPage) -> Self {
        Self {
            id: db_page.id,
            title: db_page.title,
            content: db_page.content,
            created_at: db_page.created_at,
        }
    }
}