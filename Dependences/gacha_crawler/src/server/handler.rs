use std::sync::Arc;
use tokio::sync::Mutex;
use url::Url;
use crate::ffi::gotURL;

use hudsucker::{
    async_trait::async_trait,
    hyper::{Body, Request, Response},
    tokio_tungstenite::tungstenite::Message,
    *,
};

#[derive(Clone)]
pub struct LogHandler {
    pub got_uri: Arc<Mutex<Vec<String>>>,
}

impl LogHandler {
    pub fn new(got_uri: Arc<Mutex<Vec<String>>>) -> Self {
        LogHandler {
            got_uri,
        }
    }
}

#[async_trait]
impl HttpHandler for LogHandler {
    async fn handle_request(
        &mut self,
        _ctx: &HttpContext,
        req: Request<Body>,
    ) -> RequestOrResponse {
        // println!("{:?}", req);
        println!("{}", req.uri());
        // gotURL(&req.uri().to_string());
        if is_gacha_url(&req.uri().to_string()) {
            let mut lock = self.got_uri.lock().await;
            lock.push(req.uri().to_string());
            println!("Got gacha url {}/{}", req.uri().host().unwrap(), req.uri().path());
            gotURL(&req.uri().to_string());
            println!("Count {}", lock.len());
        }
        req.into()
    }

    async fn handle_response(&mut self, _ctx: &HttpContext, res: Response<Body>) -> Response<Body> {
        // println!("{:?}", res);
        res
    }
}

#[async_trait]
impl WebSocketHandler for LogHandler {
    async fn handle_message(&mut self, _ctx: &WebSocketContext, msg: Message) -> Option<Message> {
        // println!("{:?}", msg);
        Some(msg)
    }
}

fn is_gacha_url(url: &str) -> bool {
    Url::parse(url)
    .map(|parsed_url| {
        parsed_url.path() == "/event/gacha_info/api/getGachaLog"
    })
    .unwrap_or(false)
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn check_gacha_url() {
        let correct_url = "
        https://hk4e-api.mihoyo.com/event/gacha_info/api/getGachaLog?win_mode=fullscreen&authkey_ver=1&sign_type=2&auth_appid=webview_gacha&init_type=301&gacha_id=8e72b521e716d347e3027a4f71efc08f1455d4b2&timestamp=1677627770&lang=zh-cn&device_type=mobile&game_version=CNRELiOS3.5.0_R13695448_S13586568_D13718257&plat_type=ios&region=cn_gf01&authkey=w1%2fwMrCWjV2WWTRhyeX9wMDZwIwdobxqNF5jc4tMwEFQnuJeaHlwrzbRbToUBlZ645cp45la%2fSh24U2jJSewNsVm%2f8%2fljXf8BzfNRymPJqErM%2fKhBN8zBdAygJkqBSmZlgxoHe1tAd6RIHzZPWsjfQS8Odr7qAD5X3jNAPzQIv%2fDf2ohMNOnFJPYBpCXcWC7w7o8niW7dMj4x7Cpp5x9Se0Zzw8fZuha0jWsXcfCFFbFKDFeZNmeJEAdzzuClSzyJTm8ol3iLWpNNCAekRED%2bvuNJ2p%2bZUJ49LIaJ2Rv5qc%2fvCcw3AtwbE3N5OfEzvH14iB%2fJrS1byGuDQWb149v6qjEcNW7A2PsrKtgOMRUuRokqw%2fMzMwdClZ32euJG%2bive4c0yaeySB7fTHBIsFBeRExOmoULAk9xNrdtJNyF%2fLWiVq47v0HBE9sNfNUY61mVYJGvRCLqWgKbWNhBZMMHNro%2b29if1LHwLUW5KccoiwT9UERqgpJ%2bTV%2fZAcCn4gYIc7cInR7EpsxFAPajNDol5SF59e5FJ3jRNF%2foNa6mLfaiRkRwpTi4Uf9hWNOt%2brnmoagOCr4%2bFyn0MwJjM8uWx23WsfZWI0NstBBYMGhzQskF8VYGI2sVvHd9aV%2bkr55jISo0zgFDbXIEun6Zg8pHyWJtcoKQpkfLI6eB2xSx6jIX94Rma0SxdZRvRWFsN2wwUIoal0k6pasHeMH85ZOsv6XAb8CbMT5CZY8QcHYY1brC4u8IOeyJFfTplO4Gu24HQGqlduSj3CZAmx6fM3R9G09b1s8aLEdYMBYMc%2bKmo43D6YIkrfR%2bgezvndQUknXMJPCrYOPIcb2fk0BmXB%2fYeA1yxEMHyTUezcBNvMPCIiRyfUDV6i5KjGdlp%2fSbYiYV33t7%2fFk%2bH0UvVGZ%2fgzc8nJxXEVp7Jz9b%2fcZDHqUaWnW9RIElLx6mSJKf27dhjjf5qwpIYZ9WvCb0zGAZl1r7afqp7VEuRxsTHeketxHVYqrXBkQMidIP4IfUdhfpk9r%2b&game_biz=hk4e_cn&gacha_type=200&page=3&size=5&end_id=1677643560000132361
        ";
        assert!(is_gacha_url(correct_url));

        assert!(!is_gacha_url("hello world"));

        let wrong_url = "https://webstatic.mihoyo.com/admin/mi18n/hk4e_cn/m07291724171161/m07291724171161-zh-cn.json";

        assert!(!is_gacha_url(wrong_url));

    }
}