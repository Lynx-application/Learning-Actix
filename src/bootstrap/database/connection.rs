use diesel::pg::PgConnection;
use diesel::prelude::*;
use dotenv::dotenv;
use std::env;

pub fn establish_connection() -> PgConnection {
    dotenv().ok();

    let user = env::var("DB_USER").expect("DB_USER must be set");
    let password = env::var("DB_PASSWORD").expect("DB_PASSWORD must be set");
    let host = env::var("DB_HOST").expect("DB_HOST must be set");
    let port = env::var("DB_PORT").expect("DB_PORT must be set");
    let database = env::var("DB_NAME").expect("DB_NAME must be set");
    
    let database_url = format!(
        "jdbc:postgresql://{}:{}@{}:{}/{}",
        user, password, host, port, database
    );
        
    PgConnection::establish(&database_url)
        .unwrap_or_else(|_| {
            panic!("Error connecting to the database. Please check your connection settings.");
        })
} 