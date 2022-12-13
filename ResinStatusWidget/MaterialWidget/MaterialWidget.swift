//
//  MaterialWidget.swift
//  ResinStatusWidgetExtension
//
//  Created by 戴藏龙 on 2022/11/27.
//

import Foundation
import SwiftUI
import WidgetKit

struct MaterialWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "MaterialWidget",
            provider: MaterialWidgetProvider())
        { entry in
            MaterialWidgetView(entry: entry)
        }
        .configurationDisplayName("活动和材料")
        .description("展示近日活动和今天可以获取的武器和天赋材料。")
        .supportedFamilies([.systemMedium])
    }
}

struct MaterialWidgetView: View {
    let entry: MaterialWidgetEntry
    var weaponMaterials: [WeaponOrTalentMaterial] { entry.weaponMaterials }
    var talentMaterials: [WeaponOrTalentMaterial] { entry.talentMateirals }

    var weekday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: Date())
    }

    var dayOfMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: Date())
    }

    var body: some View {
        ZStack(alignment: .leading) {
            WidgetBackgroundView(background: .randomNamecardBackground, darkModeOn: true)
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 1) {
                    Text(weekday)
                        .font(.caption)
                        .foregroundColor(Color("textColor.calendarWeekday"))
                        .bold()
                        .shadow(radius: 2)
                    HStack(spacing: 6) {
                        Text(dayOfMonth)
                            .font(.system(size: 35, weight: .regular, design: .rounded))
                            .shadow(radius: 5)
                        Spacer()
                        if entry.materialWeekday != .sunday {
                            MaterialRow(materials: weaponMaterials+talentMaterials)
                        } else {
                            Image("派蒙挺胸").resizable().scaledToFit()
                                .clipShape(Circle())
                        }
                    }
                    .frame(height: 35)
                }
                .frame(height: 40)
                .padding(.top)
                .padding(.bottom, 12)
                if let events = entry.events, !events.isEmpty {
                    EventView(events: events)
                }
                Spacer()
            }
            .padding(.horizontal)
            .foregroundColor(Color("textColor3"))
        }
    }
}

private struct EventView: View {
    let events: [EventModel]

    var body: some View {
        HStack(spacing: 4) {
            Rectangle()
                .frame(width: 2, height: 77.5)
                .offset(x: 1)
            VStack(spacing: 7) {
                ForEach(
                    events
                        .filter({ getRemainTimeInterval($0.endAt) > 0 })
                        .shuffled()
                        .prefix(4)
                        .sorted(by: { getRemainTimeInterval($0.endAt) < getRemainTimeInterval($1.endAt) }),
                    id: \.id) { content in
                    eventItem(event: content)
                }
            }
        }
        .shadow(radius: 3)
    }

    @ViewBuilder
    func eventItem(event: EventModel) -> some View {
        HStack {
            Text(" \(getLocalizedContent(event.name))")
                .lineLimit(1)
            Spacer()
            Text(timeIntervalFormattedString(getRemainTimeInterval(event.endAt)))
        }
        .font(.caption)
    }

    func getRemainTimeInterval(_ endAt: String) -> TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let endDate = dateFormatter.date(from: endAt)!
        return endDate.timeIntervalSinceReferenceDate - Date().timeIntervalSinceReferenceDate
    }

    func timeIntervalFormattedString(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.maximumUnitCount = 1
        return formatter.string(from: Date(), to: Date(timeIntervalSinceNow: timeInterval))!
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
}

private struct MaterialRow: View {
    let materials: [WeaponOrTalentMaterial]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(materials, id: \.imageString) { material in
                Image(material.imageString)
                    .resizable()
                    .scaledToFit()
            }
        }
        .shadow(radius: 1)
    }
}

struct MaterialWidgetEntry: TimelineEntry {
    let date: Date
    let materialWeekday: MaterialWeekday
    let talentMateirals: [WeaponOrTalentMaterial]
    let weaponMaterials: [WeaponOrTalentMaterial]
    let events: [EventModel]?

    init(events: [EventModel]?) {
        self.date = Date()
        self.materialWeekday = .today()
        self.talentMateirals = TalentMaterialProvider(weekday: self.materialWeekday).todaysMaterials
        self.weaponMaterials = WeaponMaterialProvider(weekday: self.materialWeekday).todaysMaterials
        self.events = events
    }
}

struct MaterialWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> MaterialWidgetEntry {
        .init(events: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (MaterialWidgetEntry) -> Void) {
        API.OpenAPIs.fetchCurrentEvents { result in
            switch result {
            case .success(let data):
                completion(.init(events: .init(data.event.values)))
            case .failure(_):
                completion(.init(events: nil))
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MaterialWidgetEntry>) -> Void) {
        API.OpenAPIs.fetchCurrentEvents { result in
            switch result {
            case .success(let data):
                completion(.init(entries: [.init(events: .init(data.event.values))], policy: .after(Calendar.current.date(byAdding: .hour, value: 4, to: Date())!)))
            case .failure(_):
                completion(
                    .init(
                        entries: [.init(events: nil)],
                        policy: .after(Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)
                    )
                )
            }
        }
    }
}
