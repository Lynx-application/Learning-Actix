use actix_web::web;

pub mod person;
pub mod page;
pub mod extra;

pub fn register_route(cfg: &mut web::ServiceConfig) {
    page::page_controller::register_routes(cfg);
    person::person_controller::register_routes(cfg);
}