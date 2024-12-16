use actix_web::web;

#[path ="./person/person_module.rs"]
pub mod person;

#[path ="./page/page_module.rs"]
pub mod page;

#[path ="./extra/extra_module.rs"]
pub mod extra;

pub fn register_route(cfg: &mut web::ServiceConfig) {
    page::page_controller::register_routes(cfg);
    person::person_controller::register_routes(cfg);
}