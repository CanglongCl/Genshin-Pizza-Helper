//
//  CharacterDetailDatasView.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/24.
//

import SwiftUI

@available(iOS 15, *)
struct EachCharacterDetailDatasView: View {
    var avatar: PlayerDetail.Avatar

    var animation: Namespace.ID

    var body: some View {
        let spacing: CGFloat = 8
        VStack {
            if #available(iOS 16, *) {
                Grid {
                    GridRow {
                        avatarIconAndSkill()
                            .padding(.bottom, spacing)
                    }
                    GridRow {
                        weapon()
                            .padding(.bottom, spacing)
                    }
                }
            } else {
                HStack {
                    avatarIconAndSkill()
                        .padding(.bottom, spacing)
                }
                HStack {
                    weapon()
                        .padding(.bottom, spacing)
                }
            }
            probView()
                .padding(.bottom, spacing)
            artifactsDetailsView()
        }
        .padding()
    }

    @ViewBuilder
    func artifactsDetailsView() -> some View {
        if !avatar.artifacts.isEmpty {
            if #available(iOS 16, *) {
                Grid {
                    GridRow {
                        ForEach(avatar.artifacts) { artifact in
                            HomeSourceWebIcon(iconString: artifact.iconString)
                                .frame(maxWidth: 60, maxHeight: 60)
                            if artifact != avatar.artifacts.last {
                                Spacer()
                            }
                        }
                    }
                    GridRow {
                        ForEach(avatar.artifacts) { artifact in
                            VStack {
                                Text(artifact.mainAttribute.name)
                                    .font(.caption)
                                    .bold()
                                Text("\(artifact.mainAttribute.valueString)")
                                    .bold()
                            }
                            if artifact != avatar.artifacts.last {
                                Spacer()
                            }
                        }
                    }
                    GridRow {
                        ForEach(avatar.artifacts) { artifact in
                            VStack {
                                ForEach(artifact.subAttributes, id:\.name) { subAttribute in
                                    Text(subAttribute.name)
                                        .font(.caption2)
                                    Text("\(subAttribute.valueString)")
                                        .font(.callout)
                                }
                            }
                            if artifact != avatar.artifacts.last {
                                Spacer()
                            }
                        }
                    }
                }
            } else {
                HStack {
                    ForEach(avatar.artifacts) { artifact in
                        VStack {
                            HomeSourceWebIcon(iconString: artifact.iconString)
                                .frame(maxWidth: 60, maxHeight: 60)
                            VStack {
                                Text(artifact.mainAttribute.name)
                                    .font(.caption)
                                    .bold()
                                Text("\(artifact.mainAttribute.valueString)")
                                    .bold()
                            }
                            VStack {
                                ForEach(artifact.subAttributes, id:\.name) { subAttribute in
                                    Text(subAttribute.name)
                                        .font(.caption2)
                                    Text("\(subAttribute.valueString)")
                                        .font(.callout)
                                }
                            }
                            Spacer()
                        }
                        .frame(maxWidth: UIScreen.main.bounds.size.width / 5)
                    }
                }
            }
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    func avatarIconAndSkill() -> some View {
        AvatarAndSkillView(avatar: avatar)
    }

    @ViewBuilder
    func weapon() -> some View {
        // Weapon
        let weapon = avatar.weapon
        let l: CGFloat = 80
        ZStack {
            EnkaWebIcon(iconString: weapon.rankLevel.rectangularBackgroundIconString)
                .scaledToFit()
                .scaleEffect(1.1)
                .offset(y: 10)
                .clipShape(Circle())
            EnkaWebIcon(iconString: weapon.awakenedIconString)
                .scaledToFit()
        }
        .frame(height: l)
        .overlay(alignment: .bottomTrailing) {
            Text("Lv.\(weapon.level)")
                .font(.caption)
                .padding(.horizontal, 3)
                .background(
                    Capsule()
                        .foregroundStyle(.ultraThinMaterial)
                        .opacity(0.7)
                )
        }
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .firstTextBaseline) {
                Text(weapon.name)
                    .bold()
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Text("精炼\(weapon.refinementRank)阶")
                    .font(.caption)
                    .padding(.horizontal)
                    .background(
                        Capsule()
                            .fill(.gray)
                            .opacity(0.25)
                    )
            }
            .padding(.bottom, 5)
            HStack {
                Text(weapon.mainAttribute.name)
                Spacer()
                Text("\(avatar.weapon.mainAttribute.valueString)")
                    .padding(.horizontal)
                    .background(
                        Capsule()
                            .fill(.gray)
                            .opacity(0.25)
                    )
            }.font(.callout)
            if let subAttribute = weapon.subAttribute {
                HStack {
                    Text(subAttribute.name)
                    Spacer()
                    Text("\(subAttribute.valueString)")
                        .padding(.horizontal)
                        .background(
                            Capsule()
                                .fill(.gray)
                                .opacity(0.25)
                        )
                }.font(.footnote)
            }
        }
        .padding(.vertical)
        .frame(height: l)
    }

    @ViewBuilder
    func probView() -> some View {
        // Other prob
        let probRows = Group {
            AttributeLabel(iconString: "UI_Icon_MaxHp", name: "生命值", value: "\(avatar.fightPropMap.HP.rounded(toPlaces: 1))")
            AttributeLabel(iconString: "UI_Icon_CurAttack", name: "攻击力", value: "\(avatar.fightPropMap.ATK.rounded(toPlaces: 1))")
            AttributeLabel(iconString: "UI_Icon_CurDefense", name: "防御力", value: "\(avatar.fightPropMap.DEF.rounded(toPlaces: 1))")
            AttributeLabel(iconString: "UI_Icon_Element", name: "元素精通", value: "\(avatar.fightPropMap.elementalMastery.rounded(toPlaces: 1))")
            AttributeLabel(iconString: "UI_Icon_Intee_WindField_ClockwiseRotation", name: "元素充能效率", value: "\((avatar.fightPropMap.energyRecharge * 100).rounded(toPlaces: 2))%")
            if avatar.fightPropMap.healingBonus > 0 {
                AttributeLabel(iconString: "UI_Icon_Heal", name: "治疗加成", value: "\((avatar.fightPropMap.healingBonus * 100).rounded(toPlaces: 2))%")
            }
            AttributeLabel(iconString: "UI_Icon_Critical", name: "暴击率", value: "\((avatar.fightPropMap.criticalRate * 100).rounded(toPlaces: 2))%")
            AttributeLabel(iconString: "UI_Icon_Critical", name: "暴击伤害", value: "\((avatar.fightPropMap.criticalDamage * 100.0).rounded(toPlaces: 2))%")
            switch avatar.element {
            case .wind:
                AttributeLabel(iconString: "UI_Icon_Element_Wind", name: "风元素伤害加成", value: "\((avatar.fightPropMap.anemoDamage * 100.0).rounded(toPlaces: 2))%")
            case .ice:
                AttributeLabel(iconString: "UI_Icon_Element_Ice", name: "冰元素伤害加成", value: "\((avatar.fightPropMap.cryoDamage * 100.0).rounded(toPlaces: 2))%")
            case .electric:
                AttributeLabel(iconString: "UI_Icon_Element_Electric", name: "雷元素伤害加成", value: "\((avatar.fightPropMap.electroDamage * 100.0).rounded(toPlaces: 2))%")
            case .water:
                AttributeLabel(iconString: "UI_Icon_Element_Water", name: "水元素伤害加成", value: "\((avatar.fightPropMap.hydroDamage * 100.0).rounded(toPlaces: 2))%")
            case .fire:
                AttributeLabel(iconString: "UI_Icon_Element_Fire", name: "火元素伤害加成", value: "\((avatar.fightPropMap.pyroDamage * 100.0).rounded(toPlaces: 2))%")
            case .rock:
                AttributeLabel(iconString: "UI_Icon_Element_Rock", name: "岩元素伤害加成", value: "\((avatar.fightPropMap.geoDamage * 100.0).rounded(toPlaces: 2))%")
            case .grass:
                AttributeLabel(iconString: "UI_Icon_Element_Grass", name: "草元素伤害加成", value: "\((avatar.fightPropMap.dendroDamage * 100.0).rounded(toPlaces: 2))%")
            default:
                EmptyView()
            }
            if avatar.fightPropMap.physicalDamage > 0 {
                AttributeLabel(iconString: "UI_Icon_PhysicalAttackUp", name: "物理伤害加成", value: "\((avatar.fightPropMap.physicalDamage * 100.0).rounded(toPlaces: 2))%")
            }
        }
        if #available(iOS 16, *) {
            Grid(verticalSpacing: 3) {
                probRows
            }
            .padding(.bottom, 10)
        } else {
            VStack(spacing: 3) {
                probRows
            }
            .padding(.bottom, 10)
        }
    }
}

@available(iOS 15.0, *)
struct AttributeLabel: View {
    let iconString: String
    let name: String
    let value: String

    let textColor: Color = .white
    let backgroundColor: Color = .white

    var body: some View {
        let image = Image(iconString)
            .resizable()
            .scaledToFit()
            .padding(.vertical, 1)
            .padding(.leading, 3)
        let nameView = Text(LocalizedStringKey(name))
        let valueView = Text(value)
            .foregroundColor(.primary)
            .padding(.horizontal)
            .background(
                Capsule()
                    .foregroundStyle(.gray)
                    .frame(height: 20)
                    .frame(maxWidth: 200)
                    .opacity(0.25)
            )
        if #available(iOS 16, *) {
            GridRow {
                image
                HStack {
                    nameView
                    Spacer()
                    valueView
                }
            }
//            GridRow {
//                Spacer()
//                nameView
//                image
//                valueView
//                Spacer()
//            }
            .frame(height: 20)
        } else {
            HStack {
                HStack {
                    image
                    nameView
                }
                Spacer()
                valueView
            }
        }
    }
}

@available(iOS 15.0, *)
private struct AvatarAndSkillView: View {
    let avatar: PlayerDetail.Avatar

    var body: some View {
        EnkaWebIcon(iconString: avatar.iconString)
            .frame(width: 85, height: 85)
            .background(EnkaWebIcon(iconString: avatar.namecardIconString)
                .scaledToFill()
                .offset(x: -85/3))
            .clipShape(Circle())
            .padding(.trailing, 3)
//            .matchedGeometryEffect(id: "character.\(avatar.name)", in: animation)
        HStack(alignment: .lastTextBaseline) {
            VStack(alignment: .leading, spacing: 6) {
                Text(avatar.name)
                    .font(.title2)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                VStack(spacing: 4) {
                    HStack {
                        Text("等级")
                        Spacer()
                        Text("\(avatar.level)")
                            .padding(.horizontal)
                            .background(
                                Capsule()
                                    .fill(.gray)
                                    .opacity(0.25)
                            )
                    }
                    HStack {
                        Text("命之座")
                        Spacer()
                        Text("\(avatar.talentCount)命")
                            .padding(.horizontal)
                            .background(
                                Capsule()
                                    .fill(.gray)
                                    .opacity(0.25)
                            )
                    }
                }
                .font(.footnote)
            }
            if #available(iOS 16, *) {
                Grid(verticalSpacing: 1) {
                    GridRow {
                        ForEach(avatar.skills, id: \.iconString) { skill in
                            VStack(spacing: 0) {
                                EnkaWebIcon(iconString: skill.iconString)
                            }
                        }
                    }
                    GridRow {
                        ForEach(avatar.skills, id: \.iconString) { skill in
                            VStack(spacing: 0) {
                                Text("\(skill.level)").font(.caption)
                            }
                        }
                    }
                }
            } else {
                HStack {
                    ForEach(avatar.skills, id: \.iconString) { skill in
                        VStack(spacing: 0) {
                            Spacer()
                            EnkaWebIcon(iconString: skill.iconString)
                            Text("\(skill.level)").font(.caption)
                            Spacer()
                        }
                    }
                }
            }
        }
        .frame(height: 85)
    }
}
