#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        type ProxyServer;

        #[swift_bridge(init)]
        fn new() -> ProxyServer;

        async fn start(&self);

        async fn stop(&self);

        fn is_running(&self) -> bool;

        fn get_uris(&self) -> Vec<String>;
    }

    extern "Swift" {
        fn gotURL(url: &str);
    }

    extern "Rust" {
        fn no_used(_str: String);
    }
}

fn no_used(_str: String) {}

mod server;

use server::ProxyServer;
