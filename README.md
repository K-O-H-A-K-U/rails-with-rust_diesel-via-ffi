# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
2.7.0

*Rust version
1.42.0

* Database creation  
postgresql used.  
create .env file at app root.  
set enviroment variables below  
  for diesel: DATABASE_URL like postgres::/{user}:{password}@{host}/{dbname}  
  for rails: DB_USERNAME, DB_PASSWORD  

# rails-with-rust_diesel-via-ffi
* init  
cd ffi/diesel_ffi  
cargo build --release  
cd ../../  
rails db:migrate  
rails runner lib/rust_seed.rb (It takes four minites)  
rails s  

and access localhost:3000
