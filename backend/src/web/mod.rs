
#[cfg(test)]
mod tests;

use std::io;
use std::env;
use std::path::{Path, PathBuf};

use rocket;
use rocket::response::NamedFile;
use rocket_contrib::{Json, Value};

use git2::Repository;
use analyzer::{list_files_in_repo, list_commits, extract_diff_info};


fn get_repo_dir() -> String {
    env::var("REPO_DIR").unwrap_or("..".to_string())
}

#[get("/")]
fn index() -> io::Result<NamedFile> {
    NamedFile::open("../frontend/static/index.html")
}

#[get("/<file..>")]
fn files(file: PathBuf) -> Option<NamedFile> {
  NamedFile::open(Path::new("../frontend/static/").join(file)).ok()
}

#[get("/files_in_repo", format="application/json")]
fn files_in_repo() -> Json<Value> {
    Repository::open(get_repo_dir())
        .and_then(|repo| list_files_in_repo(&repo))
        .map(|files| Json(json!({ "files": files })))
        .map_err(|err| Json(json!({ "error": err.message() })))
        .unwrap_or_else(|err_json| err_json)
}

#[derive(Serialize, Deserialize)]
struct DeltaBody {
    file: String
}

#[post("/deltas", format="application/json", data="<body>")]
fn get_deltas_for_file(body: Json<DeltaBody>) -> Json<Value> {
    let result = Repository::open(get_repo_dir()).and_then(|repo| {
        list_commits(&repo).map(|commits| {
            commits.filter_map(|commit| {
                extract_diff_info(&repo, commit, body.file.clone()).ok()
            }).collect::<Vec<_>>()
        })
    });
    match result {
        Ok(deltas) => Json(json!({ "deltas": deltas })),
        Err(err) => Json(json!({ "error": err.message() })),
    }
}

pub fn configure_server() -> rocket::Rocket {
    rocket::ignite()
          .mount("/", routes![index, files])
          .mount("/api/v1", routes![files_in_repo, get_deltas_for_file])
}

pub fn start_server() {
    configure_server().launch();
}
