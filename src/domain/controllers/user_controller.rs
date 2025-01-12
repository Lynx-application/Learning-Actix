use actix_web::{web, HttpResponse, Responder};
use crate::domain::models::user::NewUser;
use crate::domain::services::user_service::UserService;
use log::{error, info};

/// Create a new user
#[utoipa::path(
    post,
    path = "/api/users",
    request_body = NewUser,
    responses(
        (status = 201, description = "User created successfully", body = User),
        (status = 500, description = "Internal server error")
    ),
    tag = "users"
)]
pub async fn create_user(
    user_service: web::Data<UserService>,
    new_user: web::Json<NewUser>,
) -> impl Responder {
    match user_service.create_user(new_user.into_inner()).await {
        Ok(user) => {
            info!("User created successfully: {}", user.username);
            HttpResponse::Created().json(user)
        },
        Err(e) => {
            error!("Failed to create user: {}", e);
            HttpResponse::InternalServerError().finish()
        }
    }
}

/// Get user by ID
#[utoipa::path(
    get,
    path = "/api/users/{id}",
    params(
        ("id" = i32, Path, description = "User ID")
    ),
    responses(
        (status = 200, description = "User found", body = User),
        (status = 404, description = "User not found")
    ),
    tag = "users"
)]
pub async fn get_user(
    user_service: web::Data<UserService>,
    user_id: web::Path<i32>,
) -> impl Responder {
    match user_service.get_user(*user_id).await {
        Ok(user) => HttpResponse::Ok().json(user),
        Err(_) => HttpResponse::NotFound().finish(),
    }
}

/// Update user
#[utoipa::path(
    put,
    path = "/api/users/{id}",
    params(
        ("id" = i32, Path, description = "User ID")
    ),
    request_body = NewUser,
    responses(
        (status = 200, description = "User updated successfully", body = User),
        (status = 404, description = "User not found")
    ),
    tag = "users"
)]
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

/// Delete user
#[utoipa::path(
    delete,
    path = "/api/users/{id}",
    params(
        ("id" = i32, Path, description = "User ID")
    ),
    responses(
        (status = 204, description = "User deleted successfully"),
        (status = 404, description = "User not found"),
        (status = 500, description = "Internal server error")
    ),
    tag = "users"
)]
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
