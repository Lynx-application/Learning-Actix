use std::fs::File;
use std::io::BufReader;
use crate::models::page_struct::page;

pub fn read_json(address: &str) -> page {
    let file = File::open((address).to_string()).expect("Failed to open page_data file");
    let reader = BufReader::new(file);
    let page_data: page = serde_json::from_reader(reader).expect("Failed to parse page_data");

    page_data
}
