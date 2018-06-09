
#[cfg(test)]
mod tests;

use std::io;
use std::path::{Path, PathBuf};

use rocket;
use rocket::response::NamedFile;
use rocket_contrib::{Json, Value};
use walkdir::WalkDir;

use git2::{Repository, Error};
use analyzer::list_files_in_repo;


#[get("/")]
fn index() -> io::Result<NamedFile> {
    NamedFile::open("public/index.html")
}

#[get("/<file..>")]
fn files(file: PathBuf) -> Option<NamedFile> {
  NamedFile::open(Path::new("public/").join(file)).ok()
}

#[get("/files_in_repo", format="application/json")]
fn files_in_repo() -> Json<Value> {
    let dir = ".";  // TODO make configurable
    Repository::open(dir).and_then(|repo| {
        list_files_in_repo(&repo).map(|files| {
            Json(json!({ "files": files }))
        })
    }).map_err(|err| {
        Json(json!({ "error": err.message() }))
    }).unwrap_or_else(|err_json| err_json)
}

pub fn start_server() {
    rocket::ignite()
          .mount("/", routes![index, files])
          .mount("/api/v1", routes![files_in_repo])
          .launch();
}
