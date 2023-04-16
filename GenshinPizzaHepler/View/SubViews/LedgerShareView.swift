//
//  LedgerShareView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/14.
//

import HBMihoyoAPI
import SwiftPieChart
import SwiftUI

// MARK: - LedgerShareView

@available(iOS 15.0, *)
struct LedgerShareView: View {
    let data: LedgerData

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("\(data.dataMonth)月原石收入")
                    .font(.title).bold()
                PieChartView(
                    values: data.monthData.groupBy.map { Double($0.num) },
                    names: data.monthData.groupBy.map { $0.action },
                    formatter: { value in String(format: "%.0f", value) },
                    colors: [
                        .blue,
                        .green,
                        .orange,
                        .yellow,
                        .purple,
                        .gray,
                        .brown,
                        .cyan,
                    ],
                    backgroundColor: Color(UIColor.systemBackground),
                    innerRadiusFraction: 0.6
                )
            }
            .frame(width: 300, height: 700)
            HStack {
                Image("AppIconHD")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                Text("原神披萨小助手").bold().font(.footnote)
            }
        }
        .padding()
        .background(Color.white)
    }
}

#if DEBUG
@available(iOS 16.0, *)
struct LedgerShareView_Previews: PreviewProvider {
    static let ledgerData: LedgerData = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try! decoder.decode(LedgerData.self, from: json)
    }()

    static let json = """
      {
        "uid" : 118774161,
        "month_data" : {
          "current_primogems" : 2397,
          "current_primogems_level" : 2,
          "last_mora" : 10814740,
          "primogems_rate" : -76,
          "mora_rate" : -69,
          "group_by" : [
            {
              "percent" : 41,
              "num" : 980,
              "action_id" : 6,
              "action" : "活动奖励"
            },
            {
              "percent" : 33,
              "num" : 780,
              "action_id" : 3,
              "action" : "每日活跃"
            },
            {
              "percent" : 16,
              "num" : 400,
              "action_id" : 5,
              "action" : "邮件奖励"
            },
            {
              "percent" : 9,
              "num" : 234,
              "action_id" : 1,
              "action" : "冒险奖励"
            },
            {
              "percent" : 0,
              "num" : 0,
              "action_id" : 2,
              "action" : "任务奖励"
            },
            {
              "percent" : 0,
              "num" : 0,
              "action_id" : 4,
              "action" : "深境螺旋"
            },
            {
              "percent" : 1,
              "num" : 3,
              "action_id" : 0,
              "action" : "其他"
            }
          ],
          "last_primogems" : 10266,
          "current_mora" : 3275492
        },
        "data_month" : 10,
        "date" : "2022-10-14",
        "data_last_month" : 9,
        "region" : "cn_gf01",
        "optional_month" : [
          8,
          9,
          10
        ],
        "month" : 10,
        "nickname" : "鱼抓猫小",
        "account_id" : 193706962,
        "day_data" : {
          "current_mora" : 0,
          "last_primogems" : 140,
          "last_mora" : 109392,
          "current_primogems" : 0
        },
        "lantern" : false
      }
    """.data(using: .utf8)!

    static var previews: some View {
        if let image = generateSharePhoto() {
            Image(uiImage: image)
        }
    }

    static func generateSharePhoto() -> UIImage? {
        let renderer =
            ImageRenderer(content: LedgerShareView(data: ledgerData))
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}
#endif
