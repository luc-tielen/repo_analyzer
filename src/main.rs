
#![feature(plugin)]
#![plugin(rocket_codegen)]

extern crate rocket;
extern crate git2;

mod analyzer;


#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

fn main() {
    rocket::ignite().mount("/", routes![index]).launch();
}

