use actix_cors::Cors;
use actix_web::{http, App,HttpServer};

mod models;
mod services;

mod domain;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(move || {
        let cors = Cors::default()
            .allowed_origin("http://localhost:4200") // Update with your Angular app's URL
            .allowed_methods(vec!["GET", "POST", "OPTIONS"]) // Allowed methods
            .allowed_headers(vec![
                http::header::AUTHORIZATION,
                http::header::ACCEPT,
                http::header::CONTENT_TYPE,
            ])
            .max_age(3600);

        App::new().wrap(cors).configure(domain::register_route)
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}