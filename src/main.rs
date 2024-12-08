use actix_web::{App, HttpServer};

mod controllers;
use controllers::sample_controller::register_routes;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .configure(register_routes) // Call the configuration function
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}