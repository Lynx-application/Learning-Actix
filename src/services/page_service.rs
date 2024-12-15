use super::file_manager::read_json;
use crate::models::page_struct::Page;

pub fn get_page_service() -> Page {

    let res:Page = read_json::<Page>("src/data/page.json");

    res
}
