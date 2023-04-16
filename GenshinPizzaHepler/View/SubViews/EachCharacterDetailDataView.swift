//
//  CharacterDetailDatasView.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/24.
//

import HBPizzaHelperAPI
import SwiftUI

// MARK: - EachCharacterDetailDataView

struct EachCharacterDetailDataView: View {
    // MARK: Lifecycle

    init(avatar: PlayerDetail.Avatar, animation: Namespace.ID) {
        self.avatar = avatar
        self.animation = animation
    }

    // MARK: Internal

    static var spacingDelta: CGFloat {
        ThisDevice.useAdaptiveSpacing ? spacingDeltaAmount : 0
    }

    var avatar: PlayerDetail.Avatar

    var animation: Namespace.ID

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            //            if [.pad, .mac].contains(UIDevice.current.userInterfaceIdiom) {
            //                VStack(spacing: 6.5) {
            //                    avatarIconAndSkill()
            //                    VStack(alignment: .leading) {
            //                        artifactsDetailsView()
            //                    }
            //                }
            //                VStack(spacing: 6.5) {
            //                    probView()
            //                    weapon()
            //                }
            //            } 上述内容回头再弄
            VStack(spacing: 6.5 + Self.spacingDelta) {
                AvatarAndSkillView(avatar: avatar, fontSize: 25)
                    .padding(.bottom, 2)
                ZStack {
                    Color.black.opacity(0.1).cornerRadius(14)
                    VStack(spacing: 6.5 + Self.spacingDelta) {
                        weapon(fontSize: 25)
                        probView(fontSize: 25)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                }.fixedSize(horizontal: false, vertical: true)
                HStack(alignment: .top, spacing: Self.spacingDelta) {
                    artifactsDetailsView()
                }
            }
        }.padding(Self.spacingDeltaAmount * 7)
            .padding(.vertical, Self.spacingDeltaAmount * 5)
    }

    @ViewBuilder
    func artifactsDetailsView() -> some View {
        enumerateArtifacts().frame(maxWidth: .infinity)
    }

    @ViewBuilder
    func weapon(fontSize: CGFloat = 25) -> some View {
        HStack(alignment: .center, spacing: 19) {
            // Weapon
            let weapon = avatar.weapon
            let maxHeight: CGFloat = fontSize * 4.3 + Self.spacingDelta * 2
            ZStack {
                EnkaWebIcon(
                    iconString: weapon.rankLevel
                        .rectangularBackgroundIconString
                )
                .scaledToFit()
                .scaleEffect(1.4)
                .offset(
                    y: (maxHeight * 1.4 - maxHeight) /
                        2
                )
                .clipShape(Circle())
                EnkaWebIcon(iconString: weapon.awakenedIconString)
                    .scaledToFit()
            }
            .frame(width: maxHeight, height: maxHeight)
            .corneredTag(
                "Lv.\(weapon.level)",
                alignment: .bottom,
                textSize: ceil(fontSize * 0.86)
            )
            VStack(alignment: .leading, spacing: 3.3 + Self.spacingDelta) {
                AttributeLabel(
                    name: weapon.nameCorrected,
                    valueView: Text("精炼\(weapon.refinementRank)阶"),
                    fontSize: fontSize,
                    titleEmphasized: true,
                    hasDash: false
                )
                AttributeLabel(
                    name: weapon.mainAttribute.name
                        .percentageMarksTrimmed,
                    value: avatar.weapon.mainAttribute.valueString,
                    fontSize: fontSize,
                    hasDash: false
                )
                if let subAttribute = weapon.subAttribute {
                    AttributeLabel(
                        name: subAttribute.name.percentageMarksTrimmed,
                        value: subAttribute.valueString,
                        fontSize: fontSize,
                        hasDash: false
                    )
                }
            }
        }
    }

    @ViewBuilder
    func probView(fontSize: CGFloat = 25) -> some View {
        // Other prob
        let probRows = Group {
            if avatar.fightPropMap.healingBonus > 0 {
                AttributeLabel(
                    iconString: "UI_Icon_MaxHp",
                    name: "生命值上限".localized + " & " + "治疗加成%%".localized
                        .percentageMarksTrimmed,
                    value: "\(avatar.fightPropMap.HP.rounded(toPlaces: 1))" +
                        ", " +
                        "\((avatar.fightPropMap.healingBonus * 100).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
            } else {
                AttributeLabel(
                    iconString: "UI_Icon_MaxHp",
                    name: "生命值上限",
                    value: "\(avatar.fightPropMap.HP.rounded(toPlaces: 1))",
                    fontSize: fontSize
                )
            }
            if avatar.fightPropMap.physicalDamage > 0 {
                AttributeLabel(
                    iconString: "UI_Icon_CurAttack",
                    name: "攻击力".localized + " & " + "物伤加成%%".localized
                        .percentageMarksTrimmed,
                    value: "\(avatar.fightPropMap.ATK.rounded(toPlaces: 1))" +
                        ", " +
                        "\((avatar.fightPropMap.physicalDamage * 100.0).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
            } else {
                AttributeLabel(
                    iconString: "UI_Icon_CurAttack",
                    name: "攻击力",
                    value: "\(avatar.fightPropMap.ATK.rounded(toPlaces: 1))",
                    fontSize: fontSize
                )
            }
            AttributeLabel(
                iconString: "UI_Icon_CurDefense",
                name: "防御力",
                value: "\(avatar.fightPropMap.DEF.rounded(toPlaces: 1))",
                fontSize: fontSize
            )
            AttributeLabel(
                iconString: "UI_Icon_Element",
                name: "元素精通",
                value: "\(avatar.fightPropMap.elementalMastery.rounded(toPlaces: 1))",
                fontSize: fontSize
            )
            AttributeLabel(
                iconString: "UI_Icon_Intee_WindField_ClockwiseRotation",
                name: "元素充能效率",
                value: "\((avatar.fightPropMap.energyRecharge * 100).rounded(toPlaces: 2))%",
                fontSize: fontSize
            )
            if ThisDevice.useAdaptiveSpacing {
                AttributeLabel(
                    iconString: "UI_Icon_CriticalRate",
                    name: "暴击率",
                    value: "\((avatar.fightPropMap.criticalRate * 100).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
                AttributeLabel(
                    iconString: "UI_Icon_CriticalDamage",
                    name: "暴击伤害",
                    value: "\((avatar.fightPropMap.criticalDamage * 100.0).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
            } else {
                AttributeLabel(
                    iconString: "UI_Icon_CriticalDamage",
                    name: "暴击率".localized + " & " + "暴击伤害".localized,
                    value: "\((avatar.fightPropMap.criticalRate * 100).rounded(toPlaces: 2))%" +
                        ", " +
                        "\((avatar.fightPropMap.criticalDamage * 100.0).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
            }
            switch avatar.element {
            case .anemo:
                AttributeLabel(
                    iconString: "UI_Icon_Element_Wind",
                    name: "风元素伤害加成",
                    value: "\((avatar.fightPropMap.anemoDamage * 100.0).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
            case .cryo:
                AttributeLabel(
                    iconString: "UI_Icon_Element_Ice",
                    name: "冰元素伤害加成",
                    value: "\((avatar.fightPropMap.cryoDamage * 100.0).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
            case .electro:
                AttributeLabel(
                    iconString: "UI_Icon_Element_Electric",
                    name: "雷元素伤害加成",
                    value: "\((avatar.fightPropMap.electroDamage * 100.0).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
            case .hydro:
                AttributeLabel(
                    iconString: "UI_Icon_Element_Water",
                    name: "水元素伤害加成",
                    value: "\((avatar.fightPropMap.hydroDamage * 100.0).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
            case .pyro:
                AttributeLabel(
                    iconString: "UI_Icon_Element_Fire",
                    name: "火元素伤害加成",
                    value: "\((avatar.fightPropMap.pyroDamage * 100.0).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
            case .geo:
                AttributeLabel(
                    iconString: "UI_Icon_Element_Rock",
                    name: "岩元素伤害加成",
                    value: "\((avatar.fightPropMap.geoDamage * 100.0).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
            case .dendro:
                AttributeLabel(
                    iconString: "UI_Icon_Element_Grass",
                    name: "草元素伤害加成",
                    value: "\((avatar.fightPropMap.dendroDamage * 100.0).rounded(toPlaces: 2))%",
                    fontSize: fontSize
                )
            default:
                EmptyView()
            }
            if AppConfig.showRatingsForArtifacts,
               let totalScore = avatar.artifactTotalScore,
               let rank = avatar.artifactScoreRank {
                AttributeLabel(
                    iconString: "UI_Icon_ArtifactRating",
                    name: "圣遗物评价",
                    value: "\(String(format: "%.0f", totalScore)) (\(rank))",
                    fontSize: fontSize
                )
            }
        }
        VStack(spacing: 3.3 + Self.spacingDelta) {
            probRows
        }
    }

    @ViewBuilder
    func enumerateArtifacts(fontSize: CGFloat = 25) -> some View {
        ForEach(
            Array(avatar.artifacts.enumerated()),
            id: \.offset
        ) { seqIndex, artifact in
            // if [.pad, .mac].contains(UIDevice.current.userInterfaceIdiom) 回头再弄
            VStack(spacing: 6.5 + Self.spacingDelta) {
                perArtifactDetailView(
                    artifact,
                    seqIndex: seqIndex,
                    fontSize: fontSize
                )
            }
        }
    }

    @ViewBuilder
    func perArtifactDetailView(
        _ artifact: PlayerDetail.Avatar.Artifact,
        seqIndex: Int,
        fontSize: CGFloat = 25
    )
        -> some View {
        HomeSourceWebIcon(
            iconString: artifact
                .iconString
        )
        .scaledToFit()
        .frame(width: fontSize * 4, height: fontSize * 4 + Self.spacingDelta)
        .corneredTag(
            "Lv.\(artifact.level) ☆\(artifact.rankLevel.rawValue)",
            alignment: .bottom,
            enabled: AppConfig.showRarityAndLevelForArtifacts
        )
        .corneredTag(
            // TODO: i18n malfunction.
            "\(String(format: "%.0f", artifact.score ?? -1))分",
            alignment: .topLeading,
            enabled: artifact.score != nil && AppConfig.showRatingsForArtifacts
        )
        VStack(spacing: 0 + Self.spacingDelta) {
            Text(artifact.mainAttribute.name.percentageMarksTrimmed)
                .font(.system(size: fontSize * 0.73, weight: .bold))
            Text("\(artifact.mainAttribute.valueString)")
                .font(.systemCompressed(size: fontSize * 1.2, weight: .heavy))
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(0.5)
        }
        ForEach(
            artifact.subAttributes,
            id: \.name
        ) { subAttribute in
            VStack(spacing: 0 + Self.spacingDelta) {
                Text(subAttribute.name.percentageMarksTrimmed)
                    .font(.system(size: fontSize * 0.73))
                Text("\(subAttribute.valueString)")
                    .font(.systemCondensed(
                        size: fontSize * 1.05,
                        weight: .bold
                    ))
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.5)
            }
        }
    }

    // MARK: Private

    private static let spacingDeltaAmount: CGFloat = 5

    private var adaptiveSpacingInCharacterView: Bool {
        AppConfig.adaptiveSpacingInCharacterView
    }
}

// MARK: - AttributeLabel

struct AttributeLabel: View {
    // MARK: Lifecycle

    public init(
        iconString: String = "",
        iconStringSecondary: String? = nil,
        name: String,
        value: String,
        fontSize: CGFloat = 25,
        titleEmphasized: Bool = false,
        textColor: Color = .primary,
        backgroundColor: Color = .gray,
        hasDash: Bool = true
    ) {
        self.secondaryIconString = iconStringSecondary
        self.iconString = iconString
        self.name = name
        self.value = value
        self.valueView = Text(LocalizedStringKey(value))
        self.fontSize = fontSize
        self.titleEmphasized = titleEmphasized
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.hasDash = hasDash
    }

    public init(
        iconString: String = "",
        iconStringSecondary: String? = nil,
        name: String,
        valueView: Text,
        fontSize: CGFloat = 25,
        titleEmphasized: Bool = false,
        textColor: Color = .primary,
        backgroundColor: Color = .gray,
        hasDash: Bool = true
    ) {
        self.secondaryIconString = iconStringSecondary
        self.iconString = iconString
        self.name = name
        self.value = ""
        self.valueView = valueView
        self.fontSize = fontSize
        self.titleEmphasized = titleEmphasized
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.hasDash = hasDash
    }

    // MARK: Internal

    let iconString: String
    let secondaryIconString: String?
    let name: String
    let value: String
    let fontSize: CGFloat
    let titleEmphasized: Bool
    let textColor: Color
    let backgroundColor: Color
    let valueView: Text?
    let hasDash: Bool

    var image: some View {
        guard !iconString.isEmpty else {
            return AnyView(EmptyView())
        }
        let result = Image(iconString)
            .resizable()
            .scaledToFit()
            .frame(width: fontSize + 3, height: fontSize + 3)
            .padding(.leading, 3)
        return AnyView(result)
    }

    var secondaryImage: some View {
        guard let secondaryIconString = secondaryIconString,
              !secondaryIconString.isEmpty else {
            return AnyView(EmptyView())
        }
        let result = Image(secondaryIconString)
            .resizable()
            .scaledToFit()
            .frame(width: fontSize + 3, height: fontSize + 3)
        return AnyView(result)
    }

    var nameView: some View {
        Text(LocalizedStringKey(name))
            .font(.systemCondensed(
                size: fontSize,
                weight: titleEmphasized ? .heavy : .regular
            ))
            .fixedSize(horizontal: true, vertical: true)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
    }

    var dashSpacer: some View {
        guard hasDash else { return AnyView(Spacer()) }
        return AnyView(
            Color.white.opacity(0.1)
                .frame(maxWidth: .infinity, maxHeight: 0.5)
        )
    }

    var body: some View {
        let valueViewModified = valueView
            .font(.systemCondensed(size: fontSize, weight: .semibold))
            .foregroundColor(textColor)
            .fixedSize(horizontal: true, vertical: true)
            .minimumScaleFactor(0.5)
            .padding(.horizontal, fontSize / 2)
            .padding(.vertical, fontSize / 4)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: fontSize / 3 * 4)
            )
        HStack {
            HStack {
                HStack(spacing: 0) {
                    image
                    secondaryImage
                }
                nameView
            }
            dashSpacer
            valueViewModified
        }
        .frame(height: fontSize / 3 * 4)
    }
}

// MARK: - AvatarAndSkillView

private struct AvatarAndSkillView: View {
    // MARK: Internal

    let avatar: PlayerDetail.Avatar
    let fontSize: CGFloat

    var body: some View {
        HStack(alignment: .bottom, spacing: fontSize / 2) {
            avatar.decoratedIcon(fontSize * 5.6, cutTo: .shoulder)
                .padding(.trailing, fontSize / 5)
            VStack(alignment: .leading, spacing: 3.3 + spacingDelta) {
                HStack(alignment: .bottom) {
                    Text(avatar.nameCorrectedAndTruncated)
                        .font(.system(size: fontSize * 1.45, weight: .black))
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    // if ThisDevice.notchType == .none { Spacer().frame(width: fontSize * 1.56) }
                }
                HStack(alignment: .center, spacing: fontSize / 2) {
                    VStack(
                        alignment: .leading,
                        spacing: 3.3 + spacingDelta / 2
                    ) {
                        AttributeLabel(
                            name: "等级",
                            value: avatar.level.description,
                            hasDash: false
                        )
                        AttributeLabel(
                            name: "命之座",
                            valueView: Text("\(avatar.talentCount)命"),
                            hasDash: false
                        )
                    }
                    .font(.system(size: fontSize))
                    HStack(alignment: .lastTextBaseline, spacing: 3.3) {
                        ForEach(avatar.skills, id: \.self) { skill in
                            ZStack(alignment: .bottom) {
                                VStack {
                                    ZStack(alignment: .center) {
                                        Color.black.opacity(0.1)
                                            .clipShape(Circle())
                                        EnkaWebIcon(
                                            iconString: skill
                                                .iconString
                                        )
                                        .scaledToFit().scaleEffect(0.8)
                                    }.frame(
                                        width: fontSize * 2.6,
                                        height: fontSize * 2.6
                                    )
                                    Spacer()
                                }
                                // 这里不用 corneredTag，因为要动态调整图示与等级数字之间的显示距离。
                                // 而且 skill.levelDisplay 也不是纯文本，而是 some View。
                                ZStack(alignment: .center) {
                                    Color.black.opacity(0.1)
                                        .clipShape(Capsule())
                                    skill.levelDisplay(size: fontSize * 0.9)
                                        .padding(.horizontal, 4)
                                }.frame(height: fontSize)
                                    .fixedSize()
                            }.frame(
                                width: fontSize * 2.6,
                                height: fontSize * 3.1 + spacingDelta / 2
                            )
                        }
                    }.frame(width: 192)
                }
            }.fixedSize(horizontal: false, vertical: true)
        }
        .frame(height: fontSize * 5.6)
    }

    // MARK: Private

    private var spacingDelta: CGFloat {
        EachCharacterDetailDataView.spacingDelta
    }
}

// MARK: - Artifact Extension (SwiftUI)

extension PlayerDetail.Avatar.Artifact {
    var rankedBackgroundColor: Color {
        switch rankLevel {
        case .five: return .orange
        case .four: return .purple
        case .three: return .blue
        default: return .clear
        }
    }
}

// MARK: - Skill Extension (SwiftUI)

extension PlayerDetail.Avatar.Skill {
    var isLevelAdjusted: Bool {
        levelAdjusted != level
    }

    func levelDisplay(size: CGFloat) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("\(level)").font(.system(size: size * 0.93, weight: .heavy))
            if isLevelAdjusted {
                Text("+\(levelAdjusted - level)")
                    .font(.system(size: size * 0.8, weight: .heavy))
            }
        }
    }
}

// MARK: - Convert trailing percentage mark into a rised arrow mark.

extension String {
    fileprivate var percentageMarksTrimmed: String {
        if !contains("％"), !contains("%") { return self }
        return replacingOccurrences(of: "％", with: "")
            .replacingOccurrences(of: "%", with: "")
    }
}
