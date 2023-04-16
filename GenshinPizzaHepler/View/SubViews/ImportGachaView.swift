//
//  ImportGachaView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/4/2.
//

import AlertToast
import CoreXLSX
import SwiftUI
import UniformTypeIdentifiers

// MARK: - ImportGachaView

struct ImportGachaView: View {
    // MARK: Internal

    @StateObject
    var gachaViewModel: GachaViewModel = .shared

    @State
    var isHelpSheetShow: Bool = false

    @State
    var isCompleteAlertShow: Bool = false

    var body: some View {
        List {
            switch status {
            case .pending:
                Section {
                    PopFileButton(title: "导入UIGF JSON格式祈愿记录", allowedContentTypes: [.json]) { result in
                        switch result {
                        case let .success(url):
                            alert = .readyToStartJson(url: url)
                        case let .failure(error):
                            status = .failure(error.localizedDescription)
                        }
                    }
                    PopFileButton(title: "导入UIGF XLSX格式祈愿记录", allowedContentTypes: [.xlsx]) { result in
                        switch result {
                        case let .success(url):
                            alert = .readyToStartXlsx(url: url)
                        case let .failure(error):
                            status = .failure(error.localizedDescription)
                        }
                    }
                } footer: {
                    Text(
                        "我们支持所有严格遵守UIGF标准的导出文件。受支持的App及对应导出格式请点击右上角参阅帮助页面。"
                    )
                }
            case .reading:
                Label {
                    Text("导入中，请稍候…")
                } icon: {
                    ProgressView()
                }
            case let .succeed(info):
                Section {
                    Label {
                        Text("成功导入祈愿数据")
                    } icon: {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                    Text("UID: \(info.uid)")
                    if let app = info.app {
                        Text("数据来自：\(app)")
                    }
                    if let date = info.exportDate {
                        Text("导出时间：\(dateFormatter.string(from: date))")
                    }
                }
                Section {
                    Text("导入了\(info.totalCount)条记录")
                    Text("储存了\(info.newCount)条新记录")
                }
                Button("继续导入") {
                    status = .pending
                }
            case let .failure(string):
                Text("导入失败")
                Text("错误信息：\(string)")
                Button("重试") {
                    status = .pending
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isHelpSheetShow.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                }
            }
        })
        .sheet(isPresented: $isHelpSheetShow, content: {
            HelpSheet(isShow: $isHelpSheetShow)
        })
        .navigationTitle("导入UIGF祈愿记录")
        .onChange(of: status, perform: { newValue in
            if case .succeed = newValue {
                isCompleteAlertShow.toggle()
            }
        })
        .toast(isPresenting: $isCompleteAlertShow, alert: {
            .init(
                displayMode: .alert,
                type: .complete(.green),
                title: "成功导入祈愿数据"
            )
        })
        .alert(item: $alert) { alert in
            Alert(
                title: Text("开始导入？"),
                message: Text("导入数据需要一段时间，请耐心等待。"),
                primaryButton: .destructive(Text("开始"), action: {
                    switch alert {
                    case let .readyToStartJson(url: url):
                        processJson(url: url)
                    case let .readyToStartXlsx(url: url):
                        processXlsx(url: url)
                    }
                }),
                secondaryButton: .cancel()
            )
        }
    }

    func processJson(url: URL) {
        DispatchQueue.global(qos: .userInteractive).async {
            status = .reading
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if url.startAccessingSecurityScopedResource() {
                do {
                    let decoder = JSONDecoder()
                    decoder
                        .keyDecodingStrategy =
                        .convertFromSnakeCase
                    let data: Data = try Data(contentsOf: url)
                    let uigfModel: UIGFJson = try decoder
                        .decode(
                            UIGFJson.self,
                            from: data
                        )
                    let result = gachaViewModel
                        .importGachaFromUIGFJson(
                            uigfJson: uigfModel
                        )
                    status = .succeed(ImportSucceedInfo(
                        uid: result.uid,
                        totalCount: result.totalCount,
                        newCount: result.newCount,
                        app: uigfModel.info.exportApp,
                        exportDate: uigfModel.info.exportTime
                    ))
                    isCompleteAlertShow.toggle()
                } catch {
                    status = .failure(error.localizedDescription)
                }
                url.stopAccessingSecurityScopedResource()
            } else {
                status = .failure("无法访问文件".localized)
            }
        }
    }

    func processXlsx(url: URL) {
        DispatchQueue.global(qos: .userInteractive).async {
            status = .reading
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if url.startAccessingSecurityScopedResource() {
                do {
                    guard let file = XLSXFile(filepath: url.relativePath),
                          let workbook = try file.parseWorkbooks().first,
                          let (_, path) = try file.parseWorksheetPathsAndNames(workbook: workbook)
                          .first(where: { name, _ in
                              name == "原始数据"
                          }),
                          let worksheet = try? file.parseWorksheet(at: path),
                          let sharedStrings = try file.parseSharedStrings()
                    else {
                        status = .failure("原始数据不存在".localized); return
                    }
                    guard let head = worksheet.data?.rows.first?.cells
                        .map({ $0.stringValue(sharedStrings) }),
                        let rows = worksheet.data?.rows[1...]
                        .map({ $0.cells.map { $0.stringValue(sharedStrings) }}),
                        let gachaTypeIndex = head.firstIndex(where: { $0 == "gacha_type" }),
                        let itemTypeIndex = head.firstIndex(where: { $0 == "item_type" }),
                        let nameIndex = head.firstIndex(where: { $0 == "name" }),
                        let uidIndex = head.firstIndex(where: { $0 == "uid" }) else {
                        status = .failure("数据表缺失数据".localized); return
                    }
                    let idIndex = head.firstIndex(where: { $0 == "id" })
                    let itemIdIndex = head.firstIndex(where: { $0 == "item_id" })
                    let timeIndex = head.firstIndex(where: { $0 == "time" })
                    let langIndex = head.firstIndex(where: { $0 == "lang" })
                    let rankTypeIndex = head.firstIndex(where: { $0 == "rank_type" })
                    let countIndex = head.firstIndex(where: { $0 == "count" })
                    let items: [GachaItem_FM] = rows.compactMap { cells in
                        guard let uid = cells[uidIndex],
                              let gachaType = cells[gachaTypeIndex],
                              let itemType = cells[itemTypeIndex],
                              let name = cells[nameIndex] else {
                            return nil
                        }
                        let id: String
                        if let idIndex = idIndex,
                           let idString = cells[idIndex] {
                            id = idString
                        } else {
                            id = ""
                        }
                        let itemId: String
                        if let itemIdIndex = itemIdIndex,
                           let itemIdString = cells[itemIdIndex] {
                            itemId = itemIdString
                        } else {
                            itemId = ""
                        }
                        let count: String
                        if let countIndex = countIndex,
                           let countString = cells[countIndex] {
                            count = countString
                        } else {
                            count = "1"
                        }

                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let time: Date
                        if let timeIndex = timeIndex,
                           let timeString = cells[timeIndex],
                           let timeDate = dateFormatter.date(from: timeString) {
                            time = timeDate
                        } else {
                            time = .distantPast
                        }

                        let lang: GachaLanguageCode
                        if let langIndex = langIndex,
                           let langString = cells[langIndex],
                           let langCode = GachaLanguageCode(rawValue: langString) {
                            lang = langCode
                        } else {
                            lang = GachaTranslateManager.shared.getLanguageCode(for: name) ?? .zhCN
                        }

                        let rankType: String
                        if let rankTypeIndex = rankTypeIndex,
                           let rankTypeString = cells[rankTypeIndex] {
                            rankType = rankTypeString
                        } else {
                            rankType = "3"
                        }

                        return .init(
                            uid: uid,
                            gachaType: gachaType,
                            itemId: itemId,
                            count: count,
                            time: time,
                            name: name,
                            lang: lang,
                            itemType: itemType,
                            rankType: rankType,
                            id: id
                        )
                    }
                    let newCount = gachaViewModel.manager.addRecordItems(items)
                    if !items.isEmpty {
                        status = .succeed(.init(uid: items.first!.uid, totalCount: items.count, newCount: newCount))
                    } else {
                        status = .failure("未成功从文件中解码数据".localized)
                    }
                } catch {
                    status = .failure(error.localizedDescription)
                }
                url.stopAccessingSecurityScopedResource()
            } else {
                status = .failure("无法访问文件")
            }
        }
    }

    // MARK: Fileprivate

    @State
    fileprivate var status: ImportStatus = .pending

    // MARK: Private

    @State
    private var alert: AlertType?

    private var dateFormatter: DateFormatter {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .medium
        return fmt
    }
}

// MARK: - AlertType

private enum AlertType: Identifiable {
    case readyToStartJson(url: URL)
    case readyToStartXlsx(url: URL)

    // MARK: Internal

    var id: String {
        switch self {
        case .readyToStartJson:
            return "readyToStart"
        case .readyToStartXlsx:
            return "readyToStartXlsx"
        }
    }
}

// MARK: - ImportStatus

private enum ImportStatus {
    case pending
    case reading
    case succeed(ImportSucceedInfo)
    case failure(String)
}

// MARK: Equatable

extension ImportStatus: Equatable {}

// MARK: Identifiable

extension ImportStatus: Identifiable {
    var id: String {
        switch self {
        case .pending:
            return "pending"
        case .reading:
            return "reading"
        case .succeed:
            return "succeed"
        case .failure:
            return "failure"
        }
    }
}

// MARK: - ImportSucceedInfo

private struct ImportSucceedInfo: Equatable {
    // MARK: Lifecycle

    init(uid: String, totalCount: Int, newCount: Int, app: String? = nil, exportDate: Date? = nil) {
        self.uid = uid
        self.totalCount = totalCount
        self.newCount = newCount
        self.app = app
        self.exportDate = exportDate
    }

    // MARK: Internal

    let uid: String
    let totalCount: Int
    let newCount: Int
    let app: String?
    let exportDate: Date?
}

extension UTType {
    public static var xlsx: UTType = .init(filenameExtension: "xlsx")!
}

// MARK: - ImportFileSourceType

private enum ImportFileSourceType {
    case UIGFJSON
    case paimonXlsx
}

// MARK: - HelpSheet

private struct HelpSheet: View {
    @Binding
    var isShow: Bool

    var body: some View {
        NavigationView {
            List {
                Section {
                    if Locale.isUILanguagePanChinese {
                        Link(
                            destination: URL(
                                string: "https://uigf.org/zh/partnership.html"
                            )!
                        ) {
                            Label(
                                "支持UIGF的软件",
                                systemImage: "app.badge.checkmark"
                            )
                        }
                    } else {
                        Link(
                            destination: URL(
                                string: "https://uigf.org/en/partnership.html"
                            )!
                        ) {
                            Label(
                                "支持UIGF的软件",
                                systemImage: "app.badge.checkmark"
                            )
                        }
                    }
                } footer: {
                    Text("我们支持导入所有符合UIGF格式的文件，但我们仍发现部分宣称已支持UIGF的软件导出的记录不合标准。以下为经验证能够顺利导入本App的软件。")
                }
                Section(header: Text("以下程序或平台的JSON导出格式已通过可用性验证").textCase(.none)) {
                    Link("提瓦特小助手", destination: URL(string: "https://api.lelaer.com/ys/uploadGacha.php")!)
                    Link(
                        "genshin-wish-export",
                        destination: URL(string: "https://github.com/biuuu/genshin-wish-export")!
                    )
                    Link("寻空", destination: URL(string: "https://xunkong.cc")!)
                    Link("Yunzai-Bot", destination: URL(string: "https://gitee.com/Le-niao/Yunzai-Bot")!)
                }
                Section(header: Text("以下程序或平台的XLSX导出格式已通过可用性验证").textCase(.none)) {
                    Link("寻空", destination: URL(string: "https://xunkong.cc")!)
                    Link("Yunzai-Bot", destination: URL(string: "https://gitee.com/Le-niao/Yunzai-Bot")!)
                }
            }
            .navigationTitle("导入帮助")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        isShow.toggle()
                    }
                }
            }
        }
    }
}

// MARK: - PopFileButton

private struct PopFileButton: View {
    /// localized key
    let title: String

    let allowedContentTypes: [UTType]

    let completion: (Result<URL, Error>) -> ()

    @State
    var isFileImporterShow: Bool = false

    var body: some View {
        Button(title.localized) {
            isFileImporterShow.toggle()
        }
        .fileImporter(isPresented: $isFileImporterShow, allowedContentTypes: allowedContentTypes) { result in
            completion(result)
        }
    }
}
