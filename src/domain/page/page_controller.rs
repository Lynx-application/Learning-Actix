use actix_web::{
    get,
    web::{self},
    HttpRequest, Responder,
};

use crate::application::ip_address_service;
use super::page_service;


#[get("/page")]
pub async fn get_page_data(req: HttpRequest) -> impl Responder {
    let client_ip = req.connection_info();
    let client_ip = client_ip.realip_remote_addr().unwrap_or("unknown");

    let res = ip_address_service::ip_address_service(client_ip);

    println!("{}", res);

    let page_data = page_service::get_page_service();

    web::Json(page_data)
}

pub fn register_routes(cfg: &mut web::ServiceConfig) {
    cfg.service(get_page_data);
}
