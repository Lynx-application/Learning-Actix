use diesel::r2d2::{self, ConnectionManager};
use diesel::PgConnection;

pub type Pool = r2d2::Pool<ConnectionManager<PgConnection>>; 