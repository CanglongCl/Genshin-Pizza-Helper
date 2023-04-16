//
//  MaterialView.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/8/24.
//  今日材料部分布局

import SwiftUI

struct MaterialView: View {
    var today: MaterialWeekday = .today()

    var talentMaterialProvider: TalentMaterialProvider { .init(weekday: today) }
    var weaponMaterialProvider: WeaponMaterialProvider { .init(weekday: today) }

    var body: some View {
        if today != .sunday {
            VStack {
                HStack(spacing: -5) {
                    ForEach(
                        weaponMaterialProvider.todaysMaterials,
                        id: \.imageString
                    ) { material in
                        Image(material.imageString)
                            .resizable()
                            .scaledToFit()
                    }
                }
                HStack(spacing: -5) {
                    ForEach(
                        talentMaterialProvider.todaysMaterials,
                        id: \.imageString
                    ) { material in
                        Image(material.imageString)
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        } else {
            Text("（星期日所有材料均可获取）".localized)
                .foregroundColor(Color("textColor3"))
                .font(.caption)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
        }
    }
}
