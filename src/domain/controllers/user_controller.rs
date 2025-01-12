use actix_web::{web, HttpResponse, Responder};
use crate::domain::models::user::NewUser;
use crate::domain::services::user_service::UserService;

pub async fn create_user(
    user_service: web::Data<UserService>,
    new_user: web::Json<NewUser>,
) -> impl Responder {
    match user_service.create_user(new_user.into_inner()).await {
        Ok(user) => HttpResponse::Created().json(user),
        Err(_) => HttpResponse::InternalServerError().finish(),
    }
}

pub async fn get_user(
    user_service: web::Data<UserService>,
    user_id: web::Path<i32>,
) -> impl Responder {
    match user_service.get_user(*user_id).await {
        Ok(user) => HttpResponse::Ok().json(user),
        Err(_) => HttpResponse::NotFound().finish(),
    }
}

pub async fn update_user(
    user_service: web::Data<UserService>,
    user_id: web::Path<i32>,
    updated_user: web::Json<NewUser>,
) -> impl Responder {
    match user_service.update_user(*user_id, updated_user.into_inner()).await {
        Ok(user) => HttpResponse::Ok().json(user),
        Err(_) => HttpResponse::NotFound().finish(),
    }
}

pub async fn delete_user(
    user_service: web::Data<UserService>,
    user_id: web::Path<i32>,
) -> impl Responder {
    match user_service.delete_user(*user_id).await {
        Ok(true) => HttpResponse::NoContent().finish(),
        Ok(false) => HttpResponse::NotFound().finish(),
        Err(_) => HttpResponse::InternalServerError().finish(),
    }
}
