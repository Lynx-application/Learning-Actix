use utoipa::OpenApi;
use crate::domain::models::user::{User, NewUser};

#[derive(OpenApi)]
#[openapi(
    paths(
        crate::domain::controllers::user_controller::create_user,
        crate::domain::controllers::user_controller::get_user,
        crate::domain::controllers::user_controller::update_user,
        crate::domain::controllers::user_controller::delete_user,
    ),
    components(
        schemas(User, NewUser)
    ),
    tags(
        (name = "users", description = "User management endpoints")
    )
)]
pub struct ApiDoc; 