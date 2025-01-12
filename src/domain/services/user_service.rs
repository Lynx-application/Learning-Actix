use diesel::prelude::*;
use crate::domain::models::user::{User, NewUser};
use crate::db::Pool;

pub struct UserService {
    pool: Pool,
}

impl UserService {
    pub fn new(pool: Pool) -> Self {
        Self { pool }
    }

    pub async fn create_user(&self, new_user: NewUser) -> Result<User, diesel::result::Error> {
        use crate::schema::users;
        
        let conn = &mut self.pool.get().unwrap();
        
        diesel::insert_into(users::table)
            .values(&new_user)
            .get_result(conn)
    }

    pub async fn get_user(&self, user_id: i32) -> Result<User, diesel::result::Error> {
        use crate::schema::users::dsl::*;
        
        let conn = &mut self.pool.get().unwrap();
        
        users.find(user_id).first(conn)
    }

    pub async fn update_user(&self, user_id: i32, updated_user: NewUser) -> Result<User, diesel::result::Error> {
        use crate::schema::users::dsl::*;
        
        let conn = &mut self.pool.get().unwrap();
        
        diesel::update(users.find(user_id))
            .set((
                username.eq(updated_user.username),
                email.eq(updated_user.email),
                password_hash.eq(updated_user.password_hash),
            ))
            .get_result(conn)
    }

    pub async fn delete_user(&self, user_id: i32) -> Result<bool, diesel::result::Error> {
        use crate::schema::users::dsl::*;
        
        let conn = &mut self.pool.get().unwrap();
        
        diesel::delete(users.find(user_id))
            .execute(conn)
            .map(|count| count > 0)
    }
} 