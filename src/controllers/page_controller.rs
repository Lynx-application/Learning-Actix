use actix_web::{
    get,
    web::{self},
    Responder,
};

use crate::services::page_service;

#[get("/page")]
pub async fn get_page_data() -> impl Responder {
    let page_data = page_service::get_page_service();
    web::Json(page_data)
}

pub fn register_routes(cfg: &mut web::ServiceConfig) {
    cfg.service(get_page_data);
}
