use actix_web::web;

pub mod page_controller;
pub mod person_controller;

pub fn register_route(cfg: &mut web::ServiceConfig) {
    page_controller::register_routes(cfg);
    person_controller::register_routes(cfg);
}