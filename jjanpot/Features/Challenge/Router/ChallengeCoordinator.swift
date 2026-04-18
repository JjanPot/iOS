//
//  ChallengeCoordinator.swift
//  jjanpot
//
//  Created by 임주희 on 4/14/26.
//

import SwiftUI

final class ChallengeCoordinator: ChallengeCoordinatorProtocol {
    
    
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func showDetail(id: Int) {
        appCoordinator.push(.challengeDetail(id: id))
    }

    func showPost(id: Int) {
        appCoordinator.push(.challengePost(id: id))
    }

    func showCreate() {
        appCoordinator.push(.createChallenge)
    }

    func showReport(id: Int) {
        appCoordinator.push(.challengeReport(id: id))
    }

    func showEditFeed(challengeId: Int, entity: FeedEntity) {
        appCoordinator.push(.FeedEditFeed(challengeId: challengeId, entity: entity))
    }
    
    
    // 공용 팝업모달
    func showModal(title: String, content: String, confirmButtonTitle: String = "확인", onConfirm: @escaping () -> Void) {
        appCoordinator.showModal(title: title, content: content, confirmButtonTitle: confirmButtonTitle, onConfirm: onConfirm)
    }
    
    // 게시물 신고하기 팝업
    func showReportFeedPopup(feedId: Int, confirmAction: (() -> Void)?) {
        appCoordinator.showPopup(.reportFeedReason(feedId: feedId, confirmAction: confirmAction))
    }

    // 신고 이유 선택지 띄우기
    func showReportUserPopup(userId: Int, challengeId: Int, confirmAction: (() -> Void)?) {
        appCoordinator.showPopup(.reportUserReason(userId: userId, challengeId: challengeId, confirmAction: confirmAction))
    }

    // 사용자 신고하기 모달띄우기
    func showReportUserSheet(onReportUser: (() -> Void)?, onBlockUser: (() -> Void)?) {
        appCoordinator.sheet(.reportUser(onReportUser: onReportUser, onBlockUser: onBlockUser))
    }
    

    func closePopup() {
        appCoordinator.closePopup()
    }
    
    func closeSheet(){
        appCoordinator.closeSheet()
    }

    func close() {
        appCoordinator.pop()
    }
}
