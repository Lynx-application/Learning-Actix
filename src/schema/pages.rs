use diesel::table;

table! {
    pages (id) {
        id -> Int4,
        title -> Varchar,
        content -> Text,
        created_at -> Timestamptz,
    }
} 