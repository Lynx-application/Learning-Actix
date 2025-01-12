mod domain;

use actix_web::{web, App, HttpServer, Responder};
use serde::Deserialize;
use dotenv::dotenv;
use std::env;

#[derive(Deserialize)]
struct User {
    name: String,
}

#[actix_web::post("/user")]
async fn get_user(user_data: web::Json<User>) -> impl Responder {
    format!("Received user with name: {}", user_data.name)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();

    let host = env::var("HOST").unwrap_or_else(|_| "127.0.0.1".to_string());
    let port: u16 = env::var("PORT")
        .unwrap_or_else(|_| "8090".to_string())
        .parse()
        .expect("PORT must be a valid number");

    let db_user = env::var("POSTGRES_USER").expect("POSTGRES_USER must be set");
    let db_password = env::var("POSTGRES_PASSWORD").expect("POSTGRES_PASSWORD must be set");
    let db_name = env::var("POSTGRES_DB").expect("POSTGRES_DB must be set");
    let database_url = env::var("DATABASE_URL")
        .unwrap_or_else(|_| {
            format!(
                "postgres://{}:{}@localhost:5432/{}",
                db_user, db_password, db_name
            )
        });

    println!("Starting server at {}:{}", host, port);
    println!("Database URL: {}", database_url);

    HttpServer::new(|| {
        App::new()
            .service(domain::test_controller::test)
    })
        .bind((host.as_str(), port))?
        .run()
        .await
}
