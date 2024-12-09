use super::file_manager::read_json;
use crate::models::page_struct::page;

pub fn get_page_service() -> page {

    let res:page = read_json("src/data/page.json");

    res
}
