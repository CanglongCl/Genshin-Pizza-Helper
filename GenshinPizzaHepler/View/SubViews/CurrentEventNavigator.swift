//
//  CurrentEventNavigator.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/18.
//

import SwiftUI

struct CurrentEventNavigator: View {
    @Binding var eventContents: [EventModel]
    typealias IntervalDate = (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?)

    var body: some View {
        if !eventContents.isEmpty {
            NavigationLink {
                AllEventsView(eventContents: $eventContents)
            } label: {
                VStack(spacing: 0) {
                    HStack(spacing: 2) {
                        Text("即将结束的活动")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("查看全部活动")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.forward")
                            .padding(.leading, 5)
                            .foregroundColor(.secondary)
                    }
                    .font(.caption)
                    .padding(.top)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 13)
                    HStack(spacing: 3) {
                        Rectangle()
                            .foregroundColor(.secondary)
                            .frame(width: 4, height: 60)
                        VStack(spacing: 7) {
                            ForEach(eventContents.filter({
                                (getRemainDays($0.endAt)?.day ?? 0) >= 0
                                && (getRemainDays($0.endAt)?.hour ?? 0) >= 0
                                && (getRemainDays($0.endAt)?.minute ?? 0) >= 0
                            }).prefix(3), id: \.id) { content in
                                eventItem(event: content)
                            }
                        }
                    }
                    .padding(.bottom)
                    .padding(.horizontal, 27)
                }
                .blurMaterialBackground()
                .padding(.horizontal)
            }
        }
    }

    @ViewBuilder
    func eventItem(event: EventModel) -> some View {
        HStack {
            Text(" \(getLocalizedContent(event.name))")
                .lineLimit(1)
            Spacer()
            if getRemainDays(event.endAt) == nil {
                Text(event.endAt)
            }
            else if getRemainDays(event.endAt)!.day! > 0 {
                HStack(spacing: 0) {
                    Text("剩余 \(getRemainDays(event.endAt)!.day!)天")
                }
            }
            else {
                HStack(spacing: 0) {
                    Text("剩余 \(getRemainDays(event.endAt)!.hour!)小时")
                }
            }
        }
        .font(.caption)
        .foregroundColor(.primary)
    }

    func getLocalizedContent(_ content: EventModel.MultiLanguageContents) -> String {
        let locale = Bundle.main.preferredLocalizations.first
        switch locale {
        case "zh-Hans":
            return content.CHS
        case "zh-Hant", "zh-HK":
            return content.CHT
        case "en":
            return content.EN
        case "ja":
            return content.JP
        default:
            return content.EN
        }
    }

    func getRemainDays(_ endAt: String) -> IntervalDate? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") 
        let endDate = dateFormatter.date(from: endAt)
        guard let endDate = endDate else {
            return nil
        }
        let interval = endDate - Date()
        return interval
    }

    func getCurrentEvent() -> Void {
        DispatchQueue.global().async {
            API.OpenAPIs.fetchCurrentEvents { result in
                switch result {
                case .success(let events):
                    withAnimation {
                        self.eventContents = [EventModel](events.event.values)
                        self.eventContents = eventContents.sorted {
                            $0.endAt < $1.endAt
                        }
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
}
