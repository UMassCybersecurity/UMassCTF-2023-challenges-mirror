use axum::{
    response::Html,
    routing::{get, post},
    Json, Router,
};
use serde::Serialize;

use std::io::prelude::*;
use std::net::SocketAddr;
use std::time::Instant;

#[tokio::main]
async fn main() {
    // build our application with a route
    let app = Router::new()
        .route("/", get(homepage))
        .route("/eval", post(invoke));

    // run it
    let addr = SocketAddr::from(([0, 0, 0, 0], 3000));
    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn homepage() -> Html<&'static str> {
    Html(include_str!("../index.html"))
}

#[derive(Serialize)]
struct InvokeResult {
    time: u64,
    stdout: String,
    stderr: String,
}

async fn invoke(payload: String) -> Json<InvokeResult> {
    let webide_path = std::env::current_exe().unwrap();
    let mut child = std::process::Command::new(webide_path.parent().unwrap().join("interpreter"))
        .stdin(std::process::Stdio::piped())
        .stdout(std::process::Stdio::piped())
        .stderr(std::process::Stdio::piped())
        .spawn()
        .expect("failed to execute process");

    let mut stdin = child.stdin.take().expect("Failed to open stdin");
    stdin
        .write_all(&payload.into_bytes())
        .expect("Failed to write to stdin");
    std::mem::drop(stdin);

    let start = Instant::now();
    let output = child.wait_with_output().expect("Failed to read stdout");
    let duration = start.elapsed();

    Json(InvokeResult {
        time: duration.as_millis() as u64,
        stdout: String::from_utf8_lossy(&output.stdout).to_string(),
        stderr: String::from_utf8_lossy(&output.stderr).to_string(),
    })
}
