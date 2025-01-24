use std::fs::File;
use std::io::BufReader;
use serde::de::DeserializeOwned;


pub fn read_json<T: DeserializeOwned>(address: &str) -> T {
    let file = File::open((address).to_string()).expect("Failed to open data file");
    let reader = BufReader::new(file);
    let data: T = serde_json::from_reader(reader).expect("Failed to parse data");

    data
}
