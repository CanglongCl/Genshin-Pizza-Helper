//
//  GDGenshinDictionaryView.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/10/3.
//

import SwiftUI

@available (iOS 15, *)
struct GenshinDictionary: View {
    @State var dictionaryData: [GDDictionary]?
    @State private var searchText: String = ""
    @State private var showSafari: Bool = false
    @State private var showInfoSheet: Bool = false
    var searchResults: [GDDictionary]? {
            if searchText.isEmpty || dictionaryData == nil {
                return dictionaryData?.sorted {
                    $0.id < $1.id
                }
            } else {
                return dictionaryData!.filter {
                    $0.en.localizedCaseInsensitiveContains(searchText) ||
                    ($0.zhCN != nil && $0.zhCN!.contains(searchText)) ||
                    ($0.ja != nil && $0.ja!.contains(searchText)) ||
                    ($0.variants != nil && (($0.variants!.en != nil && $0.variants!.en!.contains(where: {$0.caseInsensitiveCompare(searchText) == .orderedSame})) ||
                                             ($0.variants!.zhCN != nil && $0.variants!.zhCN!.contains(searchText)) ||
                                             ($0.variants!.ja != nil && $0.variants!.ja!.contains(searchText)))) ||
                    ($0.tags != nil && $0.tags!.contains(where: {$0.caseInsensitiveCompare(searchText) == .orderedSame}))
                }
                .sorted {
                    $0.id < $1.id
                }
            }
        }

    let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

    var body: some View {
        if let searchResults = searchResults, let dictionaryData = dictionaryData {
            ScrollViewReader { value in
                List {
                    ForEach(alphabet, id: \.self) { letter in
                        if searchResults.filter { $0.id.hasPrefix(letter.lowercased()) }.count > 0 {
                            Section(header: Text(letter)) {
                                ForEach(searchResults.filter { $0.id.hasPrefix(letter.lowercased()) }, id: \.id) { item in
                                    dictionaryItemCell(word: item)
                                        .id(item.id)
                                        .contextMenu {
                                            Button("复制英语") {
                                                UIPasteboard.general.string = item.en
                                            }
                                            if let zhcn = item.zhCN {
                                                Button("复制中文") {
                                                    UIPasteboard.general.string = zhcn
                                                }
                                            }
                                            if let ja = item.ja {
                                                Button("复制日语") {
                                                    UIPasteboard.general.string = ja
                                                }
                                            }
                                        }
                                }
                            }.id(letter)
                        }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "支持易错字、简写和英文标签")
                .overlay(alignment: .trailing) {
                    if searchText.isEmpty {
                        VStack(spacing: 5) {
                            ForEach(0 ..< alphabet.count, id: \.self) { idx in
                                Button(action: {
                                    withAnimation {
                                        value.scrollTo(alphabet[idx], anchor: .top)
                                    }
                                }, label: {
                                    Text(alphabet[idx])
                                        .font(.footnote)
                                })
                            }
                        }
                    }
                }
            }
            .navigationTitle("原神中英日辞典")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showInfoSheet.toggle()
                    }) {
                        Image(systemName: "info.circle")
                    }
                    Button(action: {
                        showSafari.toggle()
                    }) {
                        Image(systemName: "safari")
                    }
                }
            }
            .fullScreenCover(isPresented: $showSafari, content: {
                SFSafariViewWrapper(url: URL(string: "https://genshin-dictionary.com/")!)
                    .ignoresSafeArea()
            })
            .sheet(isPresented: $showInfoSheet) {
                NavigationView {
                    VStack(alignment: .leading) {
                        Text("本功能由[原神中英日辞典](https://genshin-dictionary.com/)提供。")
                        Text("当前共收录了\(dictionaryData.count)个原神专有词语，并还在继续更新中。")
                        Text("如发现辞典内容有误或其他问题，英语&日语问题请在Twitter私信联系[シクリ](https://twitter.com/xicri_gi?s=21&t=p-r6hSgh_TXt7iddPNZM1w)，英语&中文问题请通过邮件联系[Bill Haku](mailto:i@hakubill.tech)。")
                        Spacer()
                    }
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading)
                    .navigationBarTitle("关于原神中英日辞典")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showInfoSheet.toggle()
                            }) {
                                Text("完成")
                            }
                        }
                    }
                }
            }
        } else {
            ProgressView().navigationTitle("原神中英日辞典")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showSafari.toggle()
                        }) {
                            Image(systemName: "safari")
                        }
                    }
                }
                .fullScreenCover(isPresented: $showSafari, content: {
                    SFSafariViewWrapper(url: URL(string: "https://genshin-dictionary.com/")!)
                        .ignoresSafeArea()
                })
                .onAppear {
                    DispatchQueue.global().async {
                        API.OpenAPIs.fetchGenshinDictionaryData() { result in
                            self.dictionaryData = result
                        }
                    }
                }
        }
    }

    @ViewBuilder
    func dictionaryItemCell(word: GDDictionary) -> some View {
        VStack(alignment: .leading) {
            Text("**英语** \(word.en)")
            if let zhcn = word.zhCN {
                Text("**中文** \(zhcn)")
            }
            if let ja = word.ja {
                if let jaPron = word.pronunciationJa {
                    Text("**日语** \(ja)") + Text(" (\(jaPron))").font(.footnote)
                } else {
                    Text("**日语** \(ja)")
                }
            }
            if let tags = word.tags {
                ScrollView(.horizontal) {
                    HStack(spacing: 3) {
                        ForEach(tags, id:\.self) { tag in
                            Text(tag)
                                .font(.footnote)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .background(
                                    Capsule()
                                        .fill(.blue)
                                        .frame(height: 15)
                                        .frame(maxWidth: 100)
                                )
                        }
                    }
                }
                .padding(.top, -5)
            }
        }
    }
}
