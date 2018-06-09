
#![feature(plugin)]
#![plugin(rocket_codegen)]
extern crate rocket;
extern crate rocket_contrib;
extern crate tera;
extern crate git2;

mod analyzer;
mod web;

use web::start_server;

fn main() {
    start_server();
}

