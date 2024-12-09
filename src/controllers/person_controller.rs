use actix_web::{
    get, web::{self}, Responder
};

use crate::services::person_service;


#[get("/person/{id}")]
pub async fn get_person_data(id: web::Path<String>) -> impl Responder {
    // Extracting the ID from the Path
    let person_id = id.into_inner();
    
    // Retrieve person data
    let person_data = person_service::get_person_data(&person_id);

    web::Json(person_data)
}

pub fn register_route(cfg: &mut web::ServiceConfig) {
    cfg.service(get_person_data);
}
