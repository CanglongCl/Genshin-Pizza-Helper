//
//  GetGachaClipboardView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/4/2.
//

import AlertToast
import SwiftUI

// MARK: - GetGachaClipboardView

struct GetGachaClipboardView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    @Environment(\.scenePhase)
    var scenePhase: ScenePhase

    @StateObject
    var gachaViewModel: GachaViewModel = .shared
    @StateObject
    var observer: GachaFetchProgressObserver = .shared

    @State
    var status: GetGachaStatus = .waitToStart

    @State
    fileprivate var isHelpSheetShow: Bool = false

    @State
    var urls: [String] = []

    @State
    fileprivate var alert: AlertType?

    @State
    var isCompleteGetGachaRecordAlertShow: Bool = false
    @State
    var isErrorGetGachaRecordAlertShow: Bool = false

    var body: some View {
        List {
            if urls.isEmpty {
                Section {
                    Button("从剪贴板中获取祈愿URL") {
                        if let str = UIPasteboard.general.string {
                            if case .success =
                                parseURLToAuthkeyAndOtherParams(urlString: str) {
                                withAnimation {
                                    urls.append(str)
                                }
                                alert = .getGachaURLSucceed
                            } else {
                                alert = .urlInPasteboardIsInvalid(url: str)
                            }
                        } else {
                            alert = .pasteboardNoData
                        }
                    }
                }
            } else {
                Section {
                    Label {
                        Text("成功获取到祈愿链接")
                    } icon: {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }

                } footer: {
                    HStack {
                        Spacer()
                        Button("重新获取祈愿链接") {
                            urls = []
                        }.font(.caption)
                    }
                }
            }

            if status != .running {
                Button(urls.isEmpty ? "等待祈愿链接…" : "开始获取祈愿记录") {
                    observer.initialize()
                    status = .running
                    let parseResults = urls.compactMap { urlString in
                        try? parseURLToAuthkeyAndOtherParams(
                            urlString: urlString
                        )
                        .get()
                    }
                    if parseResults.isEmpty {
                        withAnimation {
                            status =
                                .failure(.genAuthKeyError(message: "URL Error"))
                        }
                    } else {
                        let (authkey, server) = parseResults.last!
                        gachaViewModel.getGachaAndSaveFor(
                            server: server,
                            authkey: authkey,
                            observer: observer
                        ) { result in
                            switch result {
                            case .success:
                                withAnimation {
                                    status = .succeed
                                }
                            case let .failure(error):
                                withAnimation {
                                    status = .failure(error)
                                }
                            }
                        }
                    }
                }
                .disabled(urls.isEmpty)
            } else {
                GettingGachaBar()
            }
            GetGachaResultView(status: $status)
        }
        .onChange(of: status, perform: { newValue in
            switch newValue {
            case .succeed:
                isCompleteGetGachaRecordAlertShow.toggle()
            case .failure:
                isErrorGetGachaRecordAlertShow.toggle()
            default:
                break
            }
        })
        .toast(isPresenting: $isCompleteGetGachaRecordAlertShow, alert: {
            .init(
                displayMode: .alert,
                type: .complete(.green),
                title: "成功获取祈愿数据",
                subTitle: "共保存了\(observer.newItemCount)条新的祈愿数据"
            )
        })
        .toast(isPresenting: $isErrorGetGachaRecordAlertShow, alert: {
            guard case let .failure(error) = status
            else { return .init(displayMode: .alert, type: .loading) }
            return .init(
                displayMode: .alert,
                type: .error(.red),
                title: "获取失败，因为错误：\n\(error.localizedDescription)"
            )
        })
        .sheet(isPresented: $isHelpSheetShow, content: {
            HelpSheet(isPresented: $isHelpSheetShow)
        })
        .navigationBarBackButtonHidden(status == .running)
        .alert(item: $alert) { alert in
            switch alert {
            case .getGachaURLSucceed:
                return Alert(
                    title: Text("成功获取到祈愿记录链接"),
                    message: Text("请点击「开始获取祈愿记录」以继续")
                )
            case let .urlInPasteboardIsInvalid(url: url):
                return Alert(
                    title: Text("从剪贴板上获取到的链接有误"),
                    message: Text("预期应获取到祈愿链接，但获取到了错误的内容：\n\(url)")
                )
            case .pasteboardNoData:
                return Alert(title: Text("未能从剪贴板获取到内容"))
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isHelpSheetShow.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                }
            }
        }
        .navigationTitle("获取祈愿记录")
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(observer)
//        .onAppear {
//            DispatchQueue.global(qos: .background).async {
//                checkURLStorageAndGet()
//            }
//        }
    }

//    func checkURLStorageAndGet() {
//        if urls.isEmpty, let urls = popURLsFromStorage() {
//            withAnimation {
//                self.urls = urls
//                manager.stop()
//            }
//        } else {
//            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3.0) {
//                checkURLStorageAndGet()
//            }
//        }
//    }
}

// MARK: - AlertType

private enum AlertType {
    case urlInPasteboardIsInvalid(url: String)
    case getGachaURLSucceed
    case pasteboardNoData
}

// MARK: Identifiable

extension AlertType: Identifiable {
    var id: String {
        switch self {
        case let .urlInPasteboardIsInvalid(url: url):
            return "urlInPasteboardIsInvalid\(url)"
        case .getGachaURLSucceed:
            return "getGachaURLSucceed"
        case .pasteboardNoData:
            return "pasteboardNoData"
        }
    }
}

// MARK: - HelpSheet

private struct HelpSheet: View {
    @Binding
    var isPresented: Bool

    var body: some View {
        NavigationView {
            List {
                Section {
                    Link(
                        "由paimon.moe提供的获取祈愿链接的方法",
                        destination: URL(
                            string: "https://paimon.moe/wish/import"
                        )!
                    )
                } header: {
                    Text("其他获取祈愿链接的方法")
                } footer: {
                    Text("您可以将其他软件获取的祈愿链接粘贴至本软件以获取祈愿记录。但本软件不对外部程序可靠性负责。")
                }
            }
            .navigationTitle("帮助")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        isPresented.toggle()
                    }
                }
            }
        }
    }
}
