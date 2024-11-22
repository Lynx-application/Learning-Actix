use actix_web::{get, post, web, Responder};
use serde::Deserialize;

#[derive(Deserialize)]
pub struct Product {
    pub name: String,
}

// Handler for POST /product
#[post("/product")]
pub async fn create_product(product_data: web::Json<Product>) -> impl Responder {
    format!("Product created with name: {}", product_data.name)
}

// Handler for GET /product/{id}
#[get("/product/{id}")]
pub async fn get_product(product_id: web::Path<u32>) -> impl Responder {
    format!("Product ID: {}", product_id)
}
