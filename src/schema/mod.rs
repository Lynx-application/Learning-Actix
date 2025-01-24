// @generated automatically by Diesel CLI.
diesel::table! {
    pages (id) {
        id -> Int4,
        title -> Varchar,
        content -> Text,
        created_at -> Timestamptz,
    }
}

diesel::table! {
    persons (id) {
        id -> Int4,
        name -> Varchar,
        created_at -> Timestamptz,
    }
}

diesel::table! {
    ip_addresses (id) {
        id -> Int4,
        ip_address -> Varchar,
        created_at -> Timestamptz,
    }
} 