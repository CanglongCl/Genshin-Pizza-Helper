//
//  CharacterDetailDatasView.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/24.
//

import SwiftUI

struct CharacterDetailDatasView: View {
    var characterDetailData: PlayerDetails.AvatarInfo
    @Binding var charactersDetailMap: ENCharacterMap?
    @Binding var charactersLocMap: ENCharacterLoc?

    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .center) {
                    Label {
                        Text("\(getLocalizedNameFromID(id: characterDetailData.avatarId))")
                            .font(.title)
                    } icon: {
                        WebImage(urlStr: "http://ophelper.top/resource/\(getSideIconName(id: characterDetailData.avatarId)).png")
                            .frame(width: 50, height: 50)
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                Group {
                    InfoPreviewer(title: "武器", content: "\(getLocalizedNameFromMapHash(hashId: Int((characterDetailData.equipList.last?.flat.nameTextMapHash)!)!))", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                    InfoPreviewer(title: "等级", content: "\(characterDetailData.propMap.level.val)", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                    InfoPreviewer(title: "生命值", content: "\(characterDetailData.fightPropMap.HP.rounded(toPlaces: 1))", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                    InfoPreviewer(title: "攻击力", content: "\(characterDetailData.fightPropMap.ATK.rounded(toPlaces: 1))", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                    InfoPreviewer(title: "防御力", content: "\(characterDetailData.fightPropMap.DEF.rounded(toPlaces: 1))", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                    InfoPreviewer(title: "元素精通", content: "\(characterDetailData.fightPropMap.elementalMastery.rounded(toPlaces: 1))", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                    InfoPreviewer(title: "元素充能效率", content: "\((characterDetailData.fightPropMap.energyRecharge * 100).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                    InfoPreviewer(title: "治疗加成", content: "\((characterDetailData.fightPropMap.healingBonus * 100).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                    InfoPreviewer(title: "暴击率", content: "\((characterDetailData.fightPropMap.criticalRate * 100).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                    InfoPreviewer(title: "暴击伤害", content: "\((characterDetailData.fightPropMap.criticalDamage * 100.0).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                }
                Spacer()
                switch getElement(id: characterDetailData.avatarId) {
                case "Wind":
                    InfoPreviewer(title: "风元素伤害加成", content: "\((characterDetailData.fightPropMap.anemoDamage * 100.0).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                case "Ice":
                    InfoPreviewer(title: "冰元素伤害加成", content: "\((characterDetailData.fightPropMap.cryoDamage * 100.0).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                case "Electric":
                    InfoPreviewer(title: "雷元素伤害加成", content: "\((characterDetailData.fightPropMap.electroDamage * 100.0).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                case "Water":
                    InfoPreviewer(title: "水元素伤害加成", content: "\((characterDetailData.fightPropMap.hydroDamage * 100.0).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                case "Fire":
                    InfoPreviewer(title: "火元素伤害加成", content: "\((characterDetailData.fightPropMap.pyroDamage * 100.0).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                case "Rock":
                    InfoPreviewer(title: "岩元素伤害加成", content: "\((characterDetailData.fightPropMap.geoDamage * 100.0).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                case "Grass":
                    InfoPreviewer(title: "草元素伤害加成", content: "\((characterDetailData.fightPropMap.dendroDamage * 100.0).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                default:
                    EmptyView()
                }
                if characterDetailData.fightPropMap.physicalDamage > 0 {
                    InfoPreviewer(title: "物理伤害加成", content: "\((characterDetailData.fightPropMap.physicalDamage * 100.0).rounded(toPlaces: 2))%", contentStyle: .capsule, textColor: .primary, backgroundColor: .gray)
                }
                Divider()
                artifactsDetailsView()
                Spacer(minLength: 50)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(16)
        }
    }

    @ViewBuilder
    func artifactsDetailsView() -> some View {
        if #available(iOS 16, *) {
            Grid {
                GridRow {
                    ForEach(characterDetailData.equipList, id:\.itemId) { artifact in
                        if artifact.reliquary != nil {
                            WebImage(urlStr: "https://enka.network/ui/\(artifact.flat.icon).png")
                        }
                    }
                }
                GridRow {
                    ForEach(characterDetailData.equipList, id:\.itemId) { artifact in
                        if artifact.reliquary != nil {
                            VStack {
                                Text(PropertyDictionary.getLocalizedName(artifact.flat.reliquaryMainstat!.mainPropId))
                                    .font(.caption)
                                Text(floor(artifact.flat.reliquaryMainstat!.statValue) == artifact.flat.reliquaryMainstat!.statValue ? "\(Int(artifact.flat.reliquaryMainstat!.statValue))" : String(format: "%.1f", artifact.flat.reliquaryMainstat!.statValue))
                                    .bold()
                            }
                        }
                    }
                }
                GridRow {
                    ForEach(characterDetailData.equipList, id:\.itemId) { artifact in
                        if artifact.reliquary != nil {
                            VStack {
                                ForEach(artifact.flat.reliquarySubstats!, id:\.self) { substat in
                                    Text(PropertyDictionary.getLocalizedName(substat.appendPropId))
                                        .font(.caption)
                                    Text(floor(substat.statValue) == substat.statValue ? "\(Int(substat.statValue))" : String(format: "%.1f", substat.statValue))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func getNameTextMapHash(id: Int) -> Int {
        return charactersDetailMap?.characterDetails["\(id)"]?.NameTextMapHash ?? -1
    }

    func getElement(id: Int) -> String {
        return charactersDetailMap?.characterDetails["\(id)"]?.Element ?? "none"
    }

    func getSideIconName(id: Int) -> String {
        return charactersDetailMap?.characterDetails["\(id)"]?.SideIconName ?? "None"
    }

    func getAvatarIconName(id: Int) -> String {
        let sideIconName = getSideIconName(id: id)
        return sideIconName.replacingOccurrences(of: "_Side", with: "")
    }

    func getLocalizedNameFromMapHash(hashId: Int) -> String {
        switch Locale.current.languageCode {
        case "zh":
            return charactersLocMap?.zh_cn.content["\(hashId)"] ?? "Unknown"
        case "en":
            return charactersLocMap?.en.content["\(hashId)"] ?? "Unknown"
        case "ja":
            return charactersLocMap?.ja.content["\(hashId)"] ?? "Unknown"
        case "fr":
            return charactersLocMap?.fr.content["\(hashId)"] ?? "Unknown"
        default:
            return charactersLocMap?.en.content["\(hashId)"] ?? "Unknown"
        }
    }

    func getLocalizedNameFromMapHashStr(hashId: String) -> String {
        switch Locale.current.languageCode {
        case "zh":
            return charactersLocMap?.zh_cn.content[hashId] ?? "Unknown"
        case "en":
            return charactersLocMap?.en.content[hashId] ?? "Unknown"
        case "ja":
            return charactersLocMap?.ja.content[hashId] ?? "Unknown"
        case "fr":
            return charactersLocMap?.fr.content[hashId] ?? "Unknown"
        default:
            return charactersLocMap?.en.content[hashId] ?? "Unknown"
        }
    }

    func getLocalizedNameFromID(id: Int) -> String {
        let hashId = getNameTextMapHash(id: id)
        return getLocalizedNameFromMapHash(hashId: hashId)
    }
}

enum CharacterElement: String {
    case cyro = "Ice"
    case anemo = "Wind"
    case electro = "Electric"
    case hydro = "Water"
    case pryo = "Fire"
    case geo = "Rock"
    case dendro = "Grass"
    case none = "none"
}
