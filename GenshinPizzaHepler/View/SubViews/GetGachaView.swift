//
//  GetGachaView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/3/28.
//

import AlertToast
import Charts
import SwiftUI

// MARK: - GetGachaView

struct GetGachaView: View {
    @EnvironmentObject
    var viewModel: ViewModel
    @StateObject
    var gachaViewModel: GachaViewModel = .shared
    @StateObject
    var observer: GachaFetchProgressObserver = .shared

    @State
    var status: GetGachaStatus = .waitToStart
    @State
    var account: String?

    @State
    var isCompleteGetGachaRecordAlertShow: Bool = false
    @State
    var isErrorGetGachaRecordAlertShow: Bool = false

    var acountConfigsFiltered: [AccountConfiguration] {
        viewModel.accounts.compactMap {
            guard $0.config.server.region == .cn else { return nil }
            return $0.config
        }
    }

    var body: some View {
        List {
            if status != .running {
                Section {
                    Picker("选择帐号", selection: $account) {
                        Group {
                            if account == nil {
                                Text("未选择").tag(String?(nil))
                            }
                            ForEach(
                                acountConfigsFiltered,
                                id: \.uid
                            ) { account in
                                Text("\(account.name!) (\(account.uid!))")
                                    .tag(Optional(account.uid!))
                            }
                        }
                    }
                    .onAppear {
                        if account == nil {
                            account = viewModel.accounts
                                .filter { $0.config.server.region != .global }
                                .first?.config.uid
                        }
                    }
                    Button("获取祈愿记录") {
                        observer.initialize()
                        status = .running
                        let account = account!
                        gachaViewModel.getGachaAndSaveFor(
                            viewModel.accounts
                                .first(where: { $0.config.uid == account })!
                                .config,
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
                    .disabled(account == nil)
                } footer: {
                    if !viewModel.accounts.map(\.config)
                        .allSatisfy({ $0.server.region == .cn }) {
                        Text("暂不支持国际服")
                    }
                }
            } else {
                GettingGachaBar()
            }
            GetGachaResultView(status: $status)
        }
        .navigationTitle("获取祈愿记录")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(status == .running)
        .environmentObject(observer)
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
    }
}

// MARK: - GachaItemBar

private struct GachaItemBar: View {
    let item: GachaItem_FM

    var body: some View {
        VStack(spacing: 1) {
            HStack {
                Label {
                    Text(item.localizedName)
                } icon: {
                    item.decoratedIconView(30, cutTo: .face)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(
                        _GachaType(rawValue: Int(item.gachaType)!)!
                            .localizedDescription()
                    )
                    .font(.caption)
                    Text("\(item.formattedTime)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

// MARK: - GetGachaChart

@available(iOS 16.0, *)
private struct GetGachaChart: View {
    let items: [GachaItem_FM]

    let data: [GachaTypeDateCount]

    let formatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateStyle = .short
        fmt.timeStyle = .none
        return fmt
    }()

    var body: some View {
        Chart(data) {
            LineMark(
                x: .value("日期", $0.date),
                y: .value("抽数", $0.count)
            )
            .foregroundStyle(by: .value("祈愿类型", $0.type.localizedDescription()))
        }
        .chartForegroundStyleScale([
            GachaType.standard.localizedDescription(): .green,
            GachaType.character.localizedDescription(): .blue,
            GachaType.weapon.localizedDescription(): .yellow,
        ])
//        .chartXAxis {
//            AxisMarks { value in
//                AxisValueLabel(content: {
//                    if let date = value.as(Date.self) {
//                        Text(formatter.string(from: date))
//                    } else {
//                        EmptyView()
//                    }
//                })
//            }
//        }
    }
}

// MARK: - GettingGachaBar

struct GettingGachaBar: View {
    @EnvironmentObject
    var observer: GachaFetchProgressObserver

    var body: some View {
        Section {
            HStack {
                ProgressView()
                Spacer()
                Text("正在获取祈愿记录…请等待")
                Spacer()
                Button {
                    observer.shouldCancel = true
                } label: {
                    Image(systemName: "square.circle")
                }
            }
        } footer: {
            HStack {
                VStack(alignment: .leading) {
                    Text(
                        "卡池：\(observer.gachaType.localizedDescription())"
                    )
                    Text("页码：\(observer.page.description)")
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("已获取记录：\(observer.currentItems.count.description)条")
                    Text("获取到新记录：\(observer.newItemCount.description)条")
                }
            }
        }
    }
}

// MARK: - GetGachaStatus

enum GetGachaStatus: Equatable {
    case waitToStart
    case running
    case succeed
    case failure(GetGachaError)
}

// MARK: - GetGachaResultView

struct GetGachaResultView: View {
    @EnvironmentObject
    var observer: GachaFetchProgressObserver

    @Binding
    var status: GetGachaStatus

    var body: some View {
        if #available(iOS 16.0, *) {
            if (status == .succeed) || (status == .running) {
                Section {
                    GetGachaChart(
                        items: observer.currentItems,
                        data: observer.gachaTypeDateCounts
                            .sorted(by: { $0.date > $1.date })
                    )
                    .padding(.vertical)
                }
            }
        }

        if status == .succeed {
            Section {
                Label {
                    Text("成功获取祈愿数据")
                } icon: {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                }
            } footer: {
                Text(
                    "获取到\(observer.currentItems.count.description)条记录，成功保存\(observer.newItemCount.description)条新记录\n请返回上一级查看，或继续获取其他帐号的记录"
                )
            }
        }

        switch status {
        case .running, .succeed:
            let items = observer.currentItems
            if !items.isEmpty {
                Section {
                    ForEach(items.reversed()) { item in
                        GachaItemBar(item: item)
                    }
                } header: {
                    Text(status == .running ? "成功获取到一批…" : "")
                }
            }
        case let .failure(error):
            Section {
                Label {
                    Text("获取祈愿记录失败")
                } icon: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                }
                Text("ERROR: \(error.localizedDescription)")
            }
        default:
            EmptyView()
        }
    }
}
