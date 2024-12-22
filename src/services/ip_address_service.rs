use crate::{models::ip_address_struct::IpAddressStruct, services::file_manager};

pub fn ip_address_service(ip: &str)-> bool {
    
    let ip_values: Vec<&str> = ip.split(":").collect();

    let ip_address = ip_values.get(0).unwrap();
    // let port = ip_values.get(1).unwrap();

    let ips:Vec<IpAddressStruct> = file_manager::read_json::<Vec<IpAddressStruct>>("src/data/ip_addresses.json");

    let filtered_ips: Vec<IpAddressStruct> = ips
        .into_iter()
        .filter(|x| &x.address == ip_address) // Use '==' for comparison
        .collect();

    if filtered_ips.len() > 0 {
        true
    }else {
        false
    }
}
