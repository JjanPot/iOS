//
//  MainNavigationCoordinatorProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/14/26.
//

import Foundation

/// Main Feature의 네비게이션을 담당하는 기능 인터페이스
protocol MainNavigationCoordinatorProtocol: AnyObject {
    // Challenge Navigation
    func navigateToCreateChallenge()
    func navigateToChallengeDetail(id: Int)
    func navigateToChallengePost(id: Int)
    func navigateToChallengeReport(id: Int)
    func navigateToChallengeEditFeed(entity: FeedEntity)

    // MyPage Navigation
    func navigateToSettings()
    func navigateToAlarmSettings()
    func navigateToChallengeHistory()

    // Popups
    func showLoginPopup()
    func showInviteCodeInputPopup()
    func showInviteCodeCopyPopup(inviteCode: String)
    func showReportFeedPopup(feedId: Int)
    func showReportUserPopup(userId: Int, challengeId: Int)
    func showChallengeReportPopup(challengeId: Int)

    // Sheets
    func showReportUserSheet(onReportUser: (() -> Void)?, onBlockUser: (() -> Void)?)

    // Modal
//    func showReportModal(title: String, content: String, confirmButtonTitle: String, onConfirm: @escaping () -> Void)

    // WebView
    func openFullScreenWebView(url: String)

    // Navigation Control
    func closeScreen()
}
