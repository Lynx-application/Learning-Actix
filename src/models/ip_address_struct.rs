use serde::{Deserialize, Serialize};

#[derive(Deserialize, Debug, Serialize)]
pub struct IpAddressStruct {
    pub owner: String,
    pub address: String,
    pub alternatives: Vec<String>
}
