//
//  ResinRecoveryActivityController.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/11/19.
//

#if canImport(ActivityKit)
import Foundation
import ActivityKit

@available(iOS 16.1, *)
class ResinRecoveryActivityController {
    var currentActivities: [Activity<ResinRecoveryAttributes>] {
        Activity<ResinRecoveryAttributes>.activities
    }

    private init() {
        UserDefaults.standard.register(
            defaults: [
                "resinRecoveryLiveActivityShowExpedition" : true,
                "resinRecoveryLiveActivityBackgroundOptions" : "[]"
            ]
        )
    }

    static let shared: ResinRecoveryActivityController = .init()

    var allowLiveActivity: Bool {
        ActivityAuthorizationInfo.init().areActivitiesEnabled
    }

    var background: ResinRecoveryActivityBackground {
        if UserDefaults.standard.bool(forKey: "resinRecoveryLiveActivityUseEmptyBackground") {
            return .noBackground
        } else if !UserDefaults.standard.bool(forKey: "resinRecoveryLiveActivityUseCustomizeBackground") {
            return .ramdom
        } else {
            let backgrounds: [String] = .init(rawValue: UserDefaults.standard.string(forKey: "resinRecoveryLiveActivityBackgroundOptions") ?? "[]") ?? []
            if backgrounds.isEmpty {
                return .customize(["纪行・熄星"])
            } else {
                return .customize(backgrounds)
            }
        }
    }

    var showExpedition: Bool {
        UserDefaults.standard.bool(forKey: "resinRecoveryLiveActivityShowExpedition")
    }

    func createResinRecoveryTimerActivity(for account: Account) throws {
        guard allowLiveActivity else {
            throw CreateLiveActivityError.notAllowed
        }
        let accountName = account.config.name ?? ""
        let accountUUID: UUID = account.config.uuid ?? UUID()
        // TODO: debug mode
        guard let data = (try? account.result?.get()) else {
            throw CreateLiveActivityError.noInfo
        }
        guard !currentActivities.map({$0.attributes.accountUUID}).contains(account.config.uuid!) else {
            updateResinRecoveryTimerActivity(for: account)
            return
        }
        let attributes: ResinRecoveryAttributes = .init(accountName: accountName, accountUUID: accountUUID)
        let status: ResinRecoveryAttributes.ResinRecoveryState = .init(resinInfo: data.resinInfo, expeditionInfo: data.expeditionInfo, showExpedition: showExpedition, background: background)
        print("expedition=\(data.expeditionInfo.allCompleteTime)")
        do {
            let deliveryActivity = try Activity.request(attributes: attributes, contentState: status)
            print("request activity succeed ID=\(deliveryActivity.id)")
        } catch let error {
            print("Error requesting pizza delivery Live Activity \(error.localizedDescription).")
            throw CreateLiveActivityError.otherError(error.localizedDescription)
        }
    }

    func updateResinRecoveryTimerActivity(for account: Account) {
        currentActivities.filter { activity in
            activity.attributes.accountUUID == account.config.uuid ?? UUID()
        }.forEach { activity in
            Task {
                guard let data = (try? account.result?.get()) else { return }
                guard Date.now < Date(timeIntervalSinceNow: TimeInterval(data.resinInfo.recoveryTime.second)) else {
                    endActivity(for: account)
                    return
                }
                let status: ResinRecoveryAttributes.ResinRecoveryState = .init(resinInfo: data.resinInfo, expeditionInfo: data.expeditionInfo, showExpedition: showExpedition, background: background)
                await activity.update(using: status)
            }
        }
    }

    func endActivity(for account: Account) {
        currentActivities.filter { activity in
            activity.attributes.accountUUID == account.config.uuid ?? UUID()
        }.forEach { activity in
            Task {
                await activity.end()
            }
        }
    }

    func updateAllResinRecoveryTimerActivity(for accounts: [Account]) {
        accounts.forEach { account in
            updateResinRecoveryTimerActivity(for: account)
        }
    }

    func endAllActivity() {
        currentActivities.forEach { activity in
            Task {
                await activity.end()
            }
        }
    }
}

enum CreateLiveActivityError: Error {
    case notAllowed
    case otherError(String)
    case noInfo
}

extension CreateLiveActivityError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notAllowed:
            return "系统设置不允许本软件开启实时活动，请前往开启".localized
        case .noInfo:
            return "账号未获取信息".localized
        case .otherError(let message):
            return String(format: NSLocalizedString("未知错误：%@", comment: ""), message)
        }
    }
}
#endif
