mod handler;
mod proxy_server;

pub use proxy_server::ProxyServer;

// #[cfg(test)]
// mod test {
//     use std::time::Duration;
//     use tokio::join;

//     use super::*;

//     #[test]
//     fn test_is_running() {
//         let server = ProxyServer::new();
//         assert!(!server.is_running());
//     }

//     #[tokio::test]
//     async fn test_server() {
//         let server = ProxyServer::new();

//         let start = server.start();

//         let stop = async {
//             tokio::time::sleep(Duration::from_secs(5)).await;
//             server.stop().await;
//         };

//         join!(start, stop);
//     }

//     #[tokio::test]
//     async fn run_server() {
//         let server = ProxyServer::new();

//         let start = server.start();

//         let stop = async {
//             tokio::time::sleep(Duration::from_secs(5)).await;
//             println!("ProxyServer count {}", server.get_uris().len());
//         };

//         join!(start, stop);
//     }
// }