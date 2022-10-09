//
//  GetCookieWebView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/16.
//  获取Cookie的网页View

import SwiftUI
import WebKit
import SafariServices

struct GetCookieWebView: View {

    @State var isAlertShow: Bool = false

    @Binding var isShown: Bool
    @Binding var cookie: String
    let region: Region
    var dataStore: WKWebsiteDataStore = .default()
    
    let cookieKeysToSave: [String] = ["ltoken", "ltuid"]
    
    var url: String {
        switch region {
        case .cn:
            return "https://m.bbs.mihoyo.com/ys/#/login"
        case .global:
            return "https://m.hoyolab.com/"
        }
    }
    
    var httpHeaderFields: [ String : String ] {
        switch region {
        case .cn:
            return [
                "Host": "m.bbs.mihoyo.com",
                "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                "Accept-Language": "zh-CN,zh-Hans;q=0.9",
                "Connection": "keep-alive",
                "Accept-Encoding": "gzip, deflate, br",
                "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 15_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6 Mobile/15E148 Safari/604.1",
                "Cookie": ""
            ]
        case .global:
            return [
                "Host": "m.hoyolab.com",
                "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                "accept-language": "zh-CN,zh-Hans;q=0.9",
                "accept-encoding": "gzip, deflate, br",
                "user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 15_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6 Mobile/15E148 Safari/604.1",
            ]
        }
    }
    

    var body: some View {
        
        NavigationView {
            CookieGetterWebView(url: url, dataStore: dataStore, httpHeaderFields: httpHeaderFields)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("完成") {
                            cookie = ""
                            DispatchQueue.main.async {
                                dataStore.httpCookieStore.getAllCookies { cookies in
                                    cookies.forEach {
                                        print($0.name, $0.value)
                                        cookie = cookie + $0.name + "=" + $0.value + "; "
                                    }
                                }
                                isShown.toggle()
                            }
                        }
                    }
                }
                .navigationTitle("请完成登录")
                .navigationBarTitleDisplayMode(.inline)
        }
        .alert(isPresented: $isAlertShow) {
            Alert(title: Text("提示"), message: Text("请在打开的网页完成登录米游社操作后点击「完成」。\n通过Google，Facebook或Twitter登录HoYoLAB不可使用，请使用帐号密码登录。\n我们承诺：您的登录信息只会保存在您的本地设备和私人iCloud中，仅用于向米游社请求您的原神状态。"), dismissButton: .default(Text("好"))
                  )
        }
        .onAppear {
            isAlertShow.toggle()
        }
    }
}

struct CookieGetterWebView: UIViewRepresentable {
    var url: String = ""
    let dataStore: WKWebsiteDataStore
    let httpHeaderFields: [ String : String ]
    
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url)
        else {
            return WKWebView()
        }
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                    records.forEach { record in
                        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                        #if DEBUG
                            print("WKWebsiteDataStore record deleted:", record)
                        #endif
                    }
                }
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        request.allHTTPHeaderFields = httpHeaderFields
        let webview = WKWebView()
        webview.configuration.websiteDataStore = dataStore
        webview.load(request)
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: self.url) {
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
            request.httpShouldHandleCookies = false
            request.allHTTPHeaderFields = httpHeaderFields
            print(request.description)
            uiView.load(request)
        }
    }
}
