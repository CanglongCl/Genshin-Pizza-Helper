//
//  TextEditorView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/8/7.
//  封装了TextEditor和TextField的修改文本的页面

import SwiftUI

struct TextEditorView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var title: String
    var note: String? = nil
    @Binding var content: String
    var showPasteButton: Bool = false
    var showShortCutsLink: Bool = false
    
    @State private var isWebShown: Bool = false

    var body: some View {
        List {
            if showPasteButton {
                Section {
                    if showShortCutsLink {
                        Link("获取Cookie的脚本", destination: URL(string: "https://www.icloud.com/shortcuts/fe68f22c624949c9ad8959993239e19c")!)
                        Button("登录帐号获取Cookie") { isWebShown.toggle() }
                    }
                    Button("粘贴自剪贴板") {
                        content = UIPasteboard.general.string ?? ""
                    }
                }
            }
            Section(footer: Text(note ?? "").font(.footnote)) {
                TextEditor(text: $content)
                    .frame(height: 500)
            }
        }
        .navigationBarTitle(title, displayMode: .inline)
        .sheet(isPresented: $isWebShown) {
            GetCookieWebView(isShown: $isWebShown, cookie: $content, region: .cn)
        }
    }
}

struct TextFieldEditorView: View {
    var title: String
    var note: String? = nil
    @Binding var content: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        if note == nil {
            List {
                if #available(iOS 15.0, *) {
                    TextField("", text: $content)
                        .keyboardType(keyboardType)
                        .submitLabel(.done)
                } else {
                    // Fallback on earlier versions
                    TextField("", text: $content)
                        .keyboardType(keyboardType)
                }
            }
            .navigationBarTitle(title, displayMode: .inline)
        } else {
            List {
                Section(footer: Text(LocalizedStringKey(note!)).font(.footnote)) {
                    if #available(iOS 15.0, *) {
                        TextField(note!, text: $content)
                            .keyboardType(keyboardType)
                            .submitLabel(.done)
                    } else {
                        // Fallback on earlier versions
                        TextField(note!, text: $content)
                            .keyboardType(keyboardType)
                    }
                }
            }
            .navigationBarTitle(title, displayMode: .inline)
        }
    }
}
