
#[cfg(test)]
mod tests;

use rocket;
use tera::Context;
use rocket_contrib::Template;


#[get("/")]
fn index() -> Template {
    Template::render("index", &Context::new())
}

pub fn start_server() {
    rocket::ignite()
          .attach(Template::fairing())
          .mount("/", routes![index])
          .launch();
}
