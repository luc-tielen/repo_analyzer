
#![feature(plugin)]
#![plugin(rocket_codegen)]
extern crate rocket;
extern crate git2;

mod analyzer;
mod web;

use web::start_server;

fn main() {
    start_server();
}

