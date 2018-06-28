
use std::env;
use rocket::local::Client;
use rocket::http::{Status, ContentType};
use serde_json;


fn rocket_client() -> Client {
    env::set_var("REPO_DIR", "./fixtures");
    Client::new(super::configure_server()).unwrap()
}

#[test]
fn get_index_page() {
    let client = rocket_client();
    let mut resp = client.get("/").dispatch();
    assert_eq!(resp.status(), Status::Ok);
    let body = resp.body_string().unwrap();
    assert!(body.contains("src=\"/app.js\""));
}

#[test]
fn get_assets() {
    // NOTE: requires running elm-live first to generate app.js
    let client = rocket_client();
    let mut resp = client.get("/index.js").dispatch();
    assert_eq!(resp.status(), Status::Ok);
    let body = resp.body_string().unwrap();
    assert!(body.contains("Elm"));
}

#[test]
fn get_files_in_repo_via_api() {
    let client = rocket_client();
    let mut resp = client.get("/api/v1/files_in_repo").header(ContentType::JSON).dispatch();
    assert_eq!(resp.status(), Status::Ok);
    let body = resp.body_string().unwrap();
    assert!(body.contains("file1"));
    assert!(body.contains("file2"));
}

#[test]
fn get_deltas_bad_request() {
    let client = rocket_client();
    let resp = client.post("/api/v1/deltas").header(ContentType::JSON).dispatch();
    assert_eq!(resp.status(), Status::BadRequest);
}

#[test]
fn get_deltas_happy_path() {
    let client = rocket_client();
    let req_body = super::DeltaBody { file: "file1".to_string() };
    let mut resp = client.post("/api/v1/deltas")
                         .header(ContentType::JSON)
                         .body(serde_json::to_string(&req_body).unwrap())
                         .dispatch();
    assert_eq!(resp.status(), Status::Ok);
    let body = resp.body_string().unwrap();
    for x in ["commit 1", "commit 2", "commit 3", "additions", "deletions"].iter() {
        assert!(body.contains(x))
    }
}
