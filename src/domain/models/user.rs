use diesel::prelude::*;
use serde::{Deserialize, Serialize};

#[allow(dead_code)]
#[derive(Queryable, Selectable, Serialize, Deserialize)]
#[diesel(table_name = crate::schema::users)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct User {
    pub id: i32,
    pub username: String,
    pub email: String,
    #[serde(skip_serializing)]
    pub password_hash: String,
    pub created_at: chrono::NaiveDateTime,
    pub updated_at: chrono::NaiveDateTime,
}

#[allow(dead_code)]
impl User {
    pub fn verify_password(&self, password: &str) -> bool {
        // In a real application, you would use proper password hashing here
        self.password_hash == password
    }
}

#[derive(Insertable, Deserialize)]
#[diesel(table_name = crate::schema::users)]
pub struct NewUser {
    pub username: String,
    pub email: String,
    pub password_hash: String,
} 