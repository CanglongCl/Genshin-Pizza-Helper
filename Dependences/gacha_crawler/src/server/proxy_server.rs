use std::ops::Deref;
use std::sync::Arc;
use tokio::sync::Mutex;
use tokio::{
    sync::oneshot::{self, Sender},
};
use hudsucker::{
    certificate_authority::RcgenAuthority,
    *,
};
use rustls_pemfile as pemfile;
use std::{mem, net::SocketAddr};

use super::handler::{LogHandler};

#[derive(Debug)]
enum ProxyServerState {
    Running(Sender<()>),
    Stopped,
}

impl Default for ProxyServerState {
    fn default() -> Self {
        Self::Stopped
    }
}

pub struct ProxyServer {
    state: Arc<Mutex<ProxyServerState>>,
    pub got_uri: Arc<Mutex<Vec<String>>>,
}

impl ProxyServer {
    pub fn new() -> Self {
        ProxyServer {
            state: Arc::new(Mutex::new(ProxyServerState::Stopped)),
            got_uri: Arc::new(Mutex::new(Vec::new())),
        }
    }

    fn clone_got_rui(&self) -> Arc<Mutex<Vec<String>>> {
        Arc::clone(&self.got_uri)
    }

    pub fn get_uris(&self) -> Vec<String> {
        let uri = self.clone_got_rui();
        let mut lock = uri.try_lock().unwrap();
        println!("Count {}", lock.len());
        let result = lock.deref().clone();
        lock.clear();
        result
        // let mut lock = self.got_uri.lock().await;
        // println!("Count {}", lock.len());
        // let result = lock.deref().clone();
        // lock.clear();
        // result
    }

    pub fn is_running(&self) -> bool {
        use ProxyServerState::*;
        let rt = tokio::runtime::Runtime::new().unwrap();
        rt.block_on(async {
            let lock = self.state.lock().await;
            match *lock {
                Running(_) => true,
                Stopped => false,
            }
        })
    }

    pub async fn start(&self) {
        println!("Starting server...");

        let shutdown_receiver = {
            use ProxyServerState::*;
            let mut cur_state = self.state.lock().await;

            if matches!(*cur_state, Running(_)) {
                println!("Already running");
                return;
            }

            let (shutdown_sender, shutdown_receiver) = oneshot::channel();

            *cur_state = ProxyServerState::Running(shutdown_sender);

            shutdown_receiver
        };

        let mut private_key_bytes: &[u8] = include_bytes!("ca/PizzaCA.key");
        let mut ca_cert_bytes: &[u8] = include_bytes!("ca/PizzaCA.pem");
        let private_key = rustls::PrivateKey(
            pemfile::pkcs8_private_keys(&mut private_key_bytes)
                .expect("Failed to parse private key")
                .remove(0),
        );
        let ca_cert = rustls::Certificate(
            pemfile::certs(&mut ca_cert_bytes)
                .expect("Failed to parse CA certificate")
                .remove(0),
        );

        let ca = RcgenAuthority::new(private_key, ca_cert, 1_000)
            .expect("Failed to create Certificate Authority");

        let proxy = Proxy::builder()
            .with_addr(SocketAddr::from(([127, 0, 0, 1], 3000)))
            .with_rustls_client()
            .with_ca(ca)
            .with_http_handler(LogHandler::new(self.got_uri.clone()))
            .with_websocket_handler(LogHandler::new(self.got_uri.clone()))
            .build();

        println!("Server started");

        let rcv = async move { shutdown_receiver.await.unwrap() };

        if let Err(e) = proxy.start(rcv).await {
            println!("Server stopped with error: {}", e)
        }
    }

    pub async fn stop(&self) {
        use ProxyServerState::*;

        let mut lock = self.state.lock().await;

        if let Running(sender) = mem::replace(&mut *lock, Stopped) {
            let _ = sender.send(());
            println!("Server stopped");
        } else {
            println!("Server already stopped");
        }
    }
}