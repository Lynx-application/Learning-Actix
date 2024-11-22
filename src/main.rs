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

    HttpServer::new(|| {
        App::new()
            .service(domain::test_controller::test)
    })
        .bind((host.as_str(), port))?
        .run()
        .await
}
