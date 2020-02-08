mod schema;

#[macro_use]
extern crate diesel;
extern crate libc;

use diesel::prelude::*;
use diesel::pg::PgConnection;
use chrono::NaiveDateTime;
use csv::WriterBuilder;
use std::error::Error;
use dotenv;
use std::env;
use libc::*;
use std::ffi::{CString};

use schema::*;

pub fn establish_connection() -> PgConnection {
    dotenv::dotenv().ok();

    let database_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set");
    PgConnection::establish(&database_url)
        .expect(&format!("Error connecting to {}", database_url))
}

#[no_mangle]
fn take_csv() -> *const c_char {
    let connection = establish_connection();
    let results = somethings::table.inner_join(users::table)
        .select((somethings::sentence, users::name))
        .limit(5_000_000)
        .load::<SomethingWithUser>(&connection)
        .expect("Error loading somethings");

    let csv_data = make_csv(&results).unwrap();
    CString::new(csv_data).unwrap().into_raw()
}

fn make_csv(data: &Vec<SomethingWithUser>) -> Result<String, Box<dyn Error>> {
    let mut wtr = WriterBuilder::new().from_writer(vec![]);

    for some_info in data {
        wtr.write_record(&[&some_info.name, &some_info.sentence])?;
    }
    let data = String::from_utf8(wtr.into_inner()?)?;
    Ok(data)
}


#[derive(Queryable, Identifiable, PartialEq, Debug)]
#[table_name = "users"]
struct User {
    pub id: i32,
    pub name: String,
    pub created_at: Option<NaiveDateTime>,
    pub updated_at: Option<NaiveDateTime>,
}

#[derive(Queryable, Associations, Identifiable, PartialEq, Debug)]
#[belongs_to(User)]
#[table_name = "somethings"]
struct Something {
    pub id: i32,
    pub user_id: i32,
    pub int: i32,
    pub sentence: String,
    pub date: Option<NaiveDateTime>,
    pub nest: i32,
    pub created_at: Option<NaiveDateTime>,
    pub updated_at: Option<NaiveDateTime>,
}

#[derive(Queryable)]
struct SomethingWithUser {
    pub sentence: String,
    pub name: String,
}