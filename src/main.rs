// use crate_template_lynx::main as lynx_main;

// fn main() {
//     lynx_main();
// }

use your_middleware_crate_name::run_server;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let url = "127.0.0.1:8080"; // Address to bind the server

    run_server(url).await
}