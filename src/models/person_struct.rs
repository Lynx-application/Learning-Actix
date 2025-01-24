use diesel::Queryable;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct Person {
    title: String,
    description: String
}
#[derive(Queryable, Serialize, Deserialize)]
pub struct PersonQuery {
    pub id: i32,
    pub name: String,
    pub created_at: chrono::NaiveDateTime,
}