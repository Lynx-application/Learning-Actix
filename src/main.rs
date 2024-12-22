use actix_cors::Cors;
use actix_web::{http, App, HttpServer};

mod controllers;
mod models;
mod services;
mod schema;
mod bootstrap;
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // Initialize db connection on startup
    let _conn = bootstrap::database::connection::establish_connection();

    HttpServer::new(move || {
        let cors = Cors::default()
            .allowed_origin("http://localhost:4200")
            .allowed_methods(vec!["GET", "POST", "OPTIONS"])
            .allowed_headers(vec![
                http::header::AUTHORIZATION,
                http::header::ACCEPT,
                http::header::CONTENT_TYPE,
            ])
            .max_age(3600);

        App::new().wrap(cors).configure(controllers::register_route)
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}
