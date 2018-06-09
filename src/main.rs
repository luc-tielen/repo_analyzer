
#![feature(plugin)]
#![plugin(rocket_codegen)]
extern crate rocket;
#[macro_use]
extern crate rocket_contrib;
#[macro_use]
extern crate serde_derive;
extern crate git2;
extern crate walkdir;

mod analyzer;
mod web;

use web::start_server;

fn main() {
    start_server();
}

