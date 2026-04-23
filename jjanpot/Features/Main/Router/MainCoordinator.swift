//
//  MainCoordinator.swift
//  jjanpot
//
//  Created by 임주희 on 4/14/26.
//

import SwiftUI

final class MainCoordinator: MainNavigationCoordinatorProtocol {
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func navigateToCreateChallenge() {
        appCoordinator.push(.createChallenge)
    }

    func navigateToChallengeDetail(id: Int) {
        appCoordinator.push(.challengeDetail(id: id))
    }

    func navigateToFeedPost(id: Int) {
        appCoordinator.push(.feedPost(id: id))
    }

    func navigateToChallengeReport(id: Int) {
        appCoordinator.push(.challengeReport(id: id))
    }

    func navigateToFeedEditFeed(challengeId: Int, entity: FeedEntity) {
        appCoordinator.push(.feedEditFeed(challengeId: challengeId, entity: entity))
    }

    func navigateToSettings() {
        appCoordinator.push(.settings)
    }

    func navigateToAlarmSettings() {
        appCoordinator.push(.alarmSettings)
    }

    func navigateToChallengeHistory() {
        appCoordinator.push(.challengeHistory)
    }

    func showLoginPopup() {
        appCoordinator.showPopup(.login)
        
    }

    func showInviteCodeInputPopup() {
        appCoordinator.showPopup(.inviteCode_Input)
    }

    func showInviteCodeCopyPopup(inviteCode: String) {
        appCoordinator.showPopup(.inviteCode_Copy(inviteCode: inviteCode))
    }

    func showReportFeedPopup(feedId: Int) {
        appCoordinator.showPopup(.reportFeedReason(feedId: feedId, confirmAction: nil))
    }

    func showReportUserPopup(userId: Int, challengeId: Int) {
        appCoordinator.showPopup(.reportUserReason(userId: userId, challengeId: challengeId, confirmAction: nil))
    }

    func showChallengeReportPopup(challengeId: Int) {
        appCoordinator.showPopup(.reportPopup(challengeId: challengeId))
    }

    func showReportUserSheet(onReportUser: (() -> Void)?, onBlockUser: (() -> Void)?) {
        appCoordinator.sheet( .reportUser(onReportUser: onReportUser, onBlockUser: onBlockUser))
    }

    func openFullScreenWebView(url: String) {
        appCoordinator.fullScreen(url: url)
    }

    func closeScreen() {
        appCoordinator.pop()
    }
}
