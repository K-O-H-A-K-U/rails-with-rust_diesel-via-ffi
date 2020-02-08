table! {
    users (id) {
        id -> Integer,
        name -> Text,
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
    }
}

table! {
    somethings (id) {
        id -> Integer,
        user_id -> Integer,
        int -> Integer,
        #[sql_name = "str"]
        sentence -> Text,
        date -> Nullable<Timestamptz>,
        nest -> Integer,
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
    }
}

joinable!(somethings -> users (user_id));
allow_tables_to_appear_in_same_query!(somethings, users);
