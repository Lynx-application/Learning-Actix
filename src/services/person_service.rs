use super::file_manager::read_json;
use crate::models::person_struct::Person;

pub fn get_person_data(id: &str) -> Option<Person> {
    let res: Vec<Person> = read_json("src/data/people.json");

    match id {
        "1" => res.get(0).cloned(), // Use cloned() to convert &Person to Person
        "2" => res.get(1).cloned(),
        "3" => res.get(2).cloned(),
        _ => None, 
    }
}
