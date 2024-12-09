use serde::{Deserialize, Serialize};

#[derive(Deserialize, Debug, Serialize)]
pub struct page {
    pre: String,
    title: String,
    attributes: Vec<String>,
    description: String,
    tabs: Vec<String>,
}
