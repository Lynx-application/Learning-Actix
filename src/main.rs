use actix_web::{get, post, web, App, HttpServer, Responder};

#[get("/")]
async fn index() -> impl Responder {
    "Hello, Actix!"
}

#[get("/greet/{name}")]
async fn greet(name: web::Path<String>) -> impl Responder {
    format!("Hello,{}!", name)
}

#[post("/echo")]
async fn echo(req_body: String) -> impl Responder {
    format!("Recieved: {}", req_body)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(index) // root route (Main)
            .service(greet) // greet route (GET)
            .service(echo) // echo route (POST)
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}