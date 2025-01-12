use diesel::prelude::*;
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;
use chrono::NaiveDateTime;

#[allow(dead_code)]
#[derive(Queryable, Selectable, Serialize, Deserialize, ToSchema)]
#[diesel(table_name = crate::schema::users)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct User {
    pub id: i32,
    pub username: String,
    pub email: String,
    #[serde(skip_serializing)]
    pub password_hash: String,
    #[schema(value_type = String, format = "date-time", example = "2024-03-21T12:00:00")]
    pub created_at: NaiveDateTime,
    #[schema(value_type = String, format = "date-time", example = "2024-03-21T12:00:00")]
    pub updated_at: NaiveDateTime,
}

#[allow(dead_code)]
impl User {
    pub fn verify_password(&self, password: &str) -> bool {
        // In a real application, you would use proper password hashing here
        self.password_hash == password
    }
}

#[derive(Insertable, Deserialize, ToSchema)]
#[diesel(table_name = crate::schema::users)]
pub struct NewUser {
    pub username: String,
    pub email: String,
    pub password_hash: String,
} 