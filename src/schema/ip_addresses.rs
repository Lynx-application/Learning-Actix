use diesel::table;

table! {
    ip_addresses (id) {
        id -> Int4,
        ip_address -> Varchar,
        created_at -> Timestamp,
    }
} 