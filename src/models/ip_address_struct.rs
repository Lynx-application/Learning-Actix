use diesel::Queryable;
use serde::{Deserialize, Serialize};

#[derive(Deserialize, Debug, Serialize)]
pub struct IpAddressStruct {
    pub owner: String,
    pub address: String,
    pub alternatives: Vec<String>
}
#[derive(Queryable, Serialize, Deserialize)]
pub struct IpAddressQuery {
    pub id: i32,
    pub ip_address: String,
    pub created_at: chrono::NaiveDateTime,
}