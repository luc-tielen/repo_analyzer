
#[cfg(test)]
mod tests;

use std::io;
use std::path::{Path, PathBuf};
use rocket;
use rocket::response::NamedFile;


#[get("/")]
fn index() -> io::Result<NamedFile> {
    NamedFile::open("public/index.html")
}

#[get("/<file..>")]
fn files(file: PathBuf) -> Option<NamedFile> {
  NamedFile::open(Path::new("public/").join(file)).ok()
}

pub fn start_server() {
    rocket::ignite()
          .mount("/", routes![index, files])
          .launch();
}
