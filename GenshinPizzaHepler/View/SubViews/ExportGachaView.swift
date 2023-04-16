//
//  ExportGachaView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/4/3.
//

import SwiftUI
import UniformTypeIdentifiers

// MARK: - ExportGachaView

struct ExportGachaView: View {
    @EnvironmentObject
    var viewModel: ViewModel
    @StateObject
    var gachaViewModel: GachaViewModel = .shared

    @Binding
    var isSheetShow: Bool

    @ObservedObject
    fileprivate var params: ExportGachaParams = .init()

    @State
    private var isExporterPresented: Bool = false

    @State
    private var uigfJson: UIGFJson?

    @State
    fileprivate var alert: AlertType?

    var defaultFileName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        return "UIGF_\(uigfJson?.info.uid ?? "")_\(dateFormatter.string(from: uigfJson?.info.exportTime ?? Date()))"
    }

    fileprivate var file: JsonFile? {
        if let json = uigfJson {
            return .init(model: json)
        } else {
            return nil
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker("选择帐号", selection: $params.uid) {
                        Group {
                            if params.uid == nil {
                                Text("未选择").tag(String?(nil))
                            }
                            ForEach(
                                gachaViewModel.allAvaliableAccountUID,
                                id: \.self
                            ) { uid in
                                if let name = viewModel.accounts
                                    .first(where: { $0.config.uid! == uid })?.config
                                    .name {
                                    Text("\(name) (\(uid))")
                                        .tag(Optional(uid))
                                } else {
                                    Text("\(uid)")
                                        .tag(Optional(uid))
                                }
                            }
                        }
                    }
                }
                Picker("选择语言", selection: $params.lang) {
                    ForEach(GachaLanguageCode.allCases, id: \.rawValue) { code in
                        Text(code.description).tag(code)
                    }
                }
            }
            .navigationTitle("导出祈愿记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        isSheetShow.toggle()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("导出") {
                        guard let uid = params.uid else {
                            alert = .uidEmpty; return
                        }
                        let items = gachaViewModel.manager.fetchAllMO(uid: uid)
                            .map { $0.toUIGFGahcaItem(params.lang) }
                        uigfJson = .init(
                            info: .init(uid: uid, lang: params.lang),
                            list: items
                        )
                        isExporterPresented.toggle()
                    }
                    .disabled(params.uid == nil)
                }
            }
            .fileExporter(
                isPresented: $isExporterPresented,
                document: file,
                contentType: .json,
                defaultFilename: defaultFileName
            ) { result in
                switch result {
                case let .success(url):
                    alert = .succeed(url: url.absoluteString)
                case let .failure(failure):
                    alert = .failure(message: failure.localizedDescription)
                }
            }
            .alert(item: $alert) { alert in
                switch alert {
                case let .succeed(url):
                    return Alert(
                        title: Text("保存成功"),
                        message: Text("文件已保存至\(url)"),
                        dismissButton: .default(Text("好"), action: {
                            isSheetShow.toggle()
                        })
                    )
                case let .failure(error):
                    return Alert(
                        title: Text("保存失败"),
                        message: Text("错误信息：\(error)")
                    )
                case .uidEmpty:
                    return Alert(title: Text("请先选择UID"))
                }
            }
        }
    }
}

// MARK: - ExportGachaParams

private class ExportGachaParams: ObservableObject {
    @Published
    var uid: String?
    @Published
    var lang: GachaLanguageCode = .zhCN
}

// MARK: - JsonFile

private struct JsonFile: FileDocument {
    // MARK: Lifecycle

    init(configuration: ReadConfiguration) throws {
        self.model = try JSONDecoder()
            .decode(
                UIGFJson.self,
                from: configuration.file.regularFileContents!
            )
    }

    init(model: UIGFJson) {
        self.model = model
    }

    // MARK: Internal

    static var readableContentTypes: [UTType] = [.json]

    let model: UIGFJson

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(model)
        return FileWrapper(regularFileWithContents: data)
    }
}

// MARK: - AlertType

private enum AlertType: Identifiable {
    case succeed(url: String)
    case failure(message: String)
    case uidEmpty

    // MARK: Internal

    var id: String {
        switch self {
        case .succeed:
            return "succeed"
        case .failure:
            return "failure"
        case .uidEmpty:
            return "uidempty"
        }
    }
}
