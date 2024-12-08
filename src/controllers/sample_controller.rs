use actix_web::{
    get,
    web::{self},
    HttpResponse, Responder,
};

#[get("/hello")]
pub async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello from Sample Controller!")
}

#[get("/bye")]
pub async fn bye() -> impl Responder {
    HttpResponse::Ok().body("Goodbye from Sample Controller!")
}

#[get("/shoo")]
pub async fn shoo() -> impl Responder {
    HttpResponse::Ok().body("Shoo from Sample Controller!")
}

// Function to register routes dynamically
pub fn register_routes(cfg: &mut web::ServiceConfig) {
    cfg.service(hello).service(bye).service(shoo);
}
