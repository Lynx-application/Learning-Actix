mod domain;
mod schema;
mod db;

use actix_web::{web, App, HttpServer};
use diesel::r2d2::{self, ConnectionManager};
use diesel::PgConnection;
use dotenv::dotenv;
use std::env;

use crate::domain::controllers::user_controller;
use crate::domain::services::user_service::UserService;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();

    let host = env::var("HOST").unwrap_or_else(|_| "127.0.0.1".to_string());
    let port: u16 = env::var("PORT")
        .unwrap_or_else(|_| "8090".to_string())
        .parse()
        .expect("PORT must be a valid number");

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    
    // Set up database connection pool
    let manager = ConnectionManager::<PgConnection>::new(database_url);
    let pool = r2d2::Pool::builder()
        .build(manager)
        .expect("Failed to create pool");

    // Create user service
    let user_service = web::Data::new(UserService::new(pool));

    println!("Starting server at {}:{}", host, port);

    HttpServer::new(move || {
        App::new()
            .app_data(user_service.clone())
            .service(
                web::scope("/api")
                    .route("/users", web::post().to(user_controller::create_user))
                    .route("/users/{id}", web::get().to(user_controller::get_user))
                    .route("/users/{id}", web::put().to(user_controller::update_user))
                    .route("/users/{id}", web::delete().to(user_controller::delete_user))
            )
    })
    .bind((host.as_str(), port))?
    .run()
    .await
}
