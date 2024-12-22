use diesel::table;

table! {
    persons (id) {
        id -> Int4,
        name -> Varchar,
        created_at -> Timestamp,
    }
} 