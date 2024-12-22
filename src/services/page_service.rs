use diesel::prelude::*;
use crate::bootstrap::database::connection;
use crate::models::page_struct::{Page, NewPage, DbPage};
use crate::schema::pages;
use super::file_manager::read_json;

pub fn get_page_service() -> Page {
    read_json::<Page>("src/data/page.json")
}

pub fn create_page(title: &str, content: &str) -> QueryResult<Page> {
    let conn = &mut connection::establish_connection();
    
    let new_page = NewPage {
        title,
        content,
    };

    let db_page = diesel::insert_into(pages::table)
        .values(&new_page)
        .get_result::<DbPage>(conn)?;

    Ok(Page::from(db_page))
}

pub fn get_all_pages() -> QueryResult<Vec<Page>> {
    let conn = &mut connection::establish_connection();
    let db_pages = pages::table.load::<DbPage>(conn)?;
    
    Ok(db_pages.into_iter().map(Page::from).collect())
}
