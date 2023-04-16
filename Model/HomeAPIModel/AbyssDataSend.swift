//
//  AbyssData.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/9.
//

import Foundation
import HBMihoyoAPI

// MARK: - AvatarHoldingData

struct AvatarHoldingData: Codable {
    /// 混淆后的UID的哈希值，用于标记是哪一位玩家打的深渊
    let uid: String
    /// 深渊期数，格式为年月日+上/下半月，其中上半月用奇数表示，下半月后偶数表示，如"2022101"
    var updateDate: String
    /// 玩家已解锁角色
    let owningChars: [Int]
    /// 帐号所属服务器ID
    let serverId: String
}

// MARK: - AbyssData

/// 用于向服务器发送的深渊数据
struct AbyssData: Codable {
    struct SubmitDetailModel: Codable {
        /// 深渊层数
        let floor: Int
        /// 深渊间数
        let room: Int
        /// 上半间/下半间，1表示上半，2表示下半
        let half: Int

        /// 使用了哪些角色
        let usedChars: [Int]
    }

    struct AbyssRankModel: Codable {
        /// 造成的最高伤害
        let topDamageValue: Int

        /// 最高伤害的角色ID，下同
        let topDamage: Int
        let topTakeDamage: Int
        let topDefeat: Int
        let topEUsed: Int
        let topQUsed: Int
    }

    /// 提交数据的ID
    var submitId: String = UUID().uuidString

    /// 混淆后的UID的哈希值，用于标记是哪一位玩家打的深渊
    let uid: String

    /// 提交时间的时间戳since1970
    var submitTime: Int = .init(Date().timeIntervalSince1970)

    /// 深渊期数，格式为年月日+上/下半月，其中上半月用奇数表示，下半月后偶数表示，如"2022101"
    var abyssSeason: Int

    /// 帐号服务器ID
    let server: String

    /// 每半间深渊的数据
    let submitDetails: [SubmitDetailModel]

    /// 深渊伤害等数据的排名统计
    let abyssRank: AbyssRankModel?

    /// 玩家已解锁角色
    let owningChars: [Int]

    /// 战斗次数
    let battleCount: Int

    /// 获胜次数
    let winCount: Int

    /// 返回结尾只有0或1的abyssSeason信息
    func getLocalAbyssSeason() -> Int {
        if abyssSeason % 2 == 0 {
            return (abyssSeason / 10) * 10
        } else {
            return (abyssSeason / 10) * 10 + 1
        }
    }
}

extension AbyssData {
    init?(
        account: Account,
        which season: AccountSpiralAbyssDetail.WhichSeason
    ) {
        guard let abyssData = account.spiralAbyssDetail?.get(season),
              let basicInfo = account.basicInfo
        else { return nil }
        guard abyssData.totalStar == 36 else { return nil }
        let obfuscatedUid =
            "\(account.config.uid!)\(account.config.uid!.md5)\(AppConfig.uidSalt)"
        self.uid = obfuscatedUid.md5
        self.server = account.config.server.id

        let component = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: Date(timeIntervalSince1970: Double(abyssData.startTime)!)
        )
        let abyssDataDate =
            Date(timeIntervalSince1970: Double(abyssData.startTime)!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        let abyssSeasonStr = dateFormatter.string(from: abyssDataDate)
        guard let abyssSeasonInt = Int(abyssSeasonStr) else {
            return nil
        }
        if component.day! <= 15 {
            let evenNumber = [0, 2, 4, 6, 8]
            self.abyssSeason = abyssSeasonInt * 10 + evenNumber.randomElement()!
        } else {
            let oddNumber = [1, 3, 5, 7, 9]
            self.abyssSeason = abyssSeasonInt * 10 + oddNumber.randomElement()!
        }

        self.owningChars = basicInfo.avatars.map { $0.id }
        self.abyssRank = .init(data: abyssData)
        self.submitDetails = .generateArrayFrom(
            data: abyssData,
            basicInfo: basicInfo
        )
        print(submitDetails.count)
        guard submitDetails.count == 4 * 3 * 2 else {
            print(
                "submitDetails only has \(submitDetails.count), fail to create data"
            )
            return nil
        }
        self.battleCount = abyssData.totalBattleTimes
        self.winCount = abyssData.totalWinTimes
    }
}

extension AbyssData.AbyssRankModel {
    init?(data: SpiralAbyssDetail) {
        guard [
            data.damageRank.first,
            data.defeatRank.first,
            data.takeDamageRank.first,
            data.energySkillRank.first,
            data.normalSkillRank.first,
        ].allSatisfy({ $0 != nil }) else { return nil }
        topDamageValue = data.damageRank.first?.value ?? 0
        topDamage = data.damageRank.first?.avatarId ?? -1
        topDefeat = data.defeatRank.first?.avatarId ?? -1
        topTakeDamage = data.takeDamageRank.first?.avatarId ?? -1
        topQUsed = data.energySkillRank.first?.avatarId ?? -1
        topEUsed = data.normalSkillRank.first?.avatarId ?? -1
    }
}

extension Array where Element == AbyssData.SubmitDetailModel {
    static func generateArrayFrom(
        data: SpiralAbyssDetail,
        basicInfo: BasicInfos
    ) -> [AbyssData.SubmitDetailModel] {
        data.floors.flatMap { floor in
            floor.levels.flatMap { level in
                level.battles.compactMap { battle in
                    if floor.gainAllStar {
                        return .init(
                            floor: floor.index,
                            room: level.index,
                            half: battle.index,
                            usedChars: battle.avatars
                                .sorted(by: { $0.id < $1.id }).map { $0.id }
                        )
                    } else { return nil }
                }
            }
        }
    }
}

extension AvatarHoldingData {
    init?(
        account: Account,
        which season: AccountSpiralAbyssDetail.WhichSeason
    ) {
        guard let basicInfo = account.basicInfo else { return nil }
        let obfuscatedUid =
            "\(account.config.uid!)\(account.config.uid!.md5)\(AppConfig.uidSalt)"
        self.uid = String(obfuscatedUid.md5)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        self.updateDate = formatter.string(from: Date())

        self.owningChars = basicInfo.avatars.map { $0.id }
        self.serverId = account.config.server.id
    }
}
