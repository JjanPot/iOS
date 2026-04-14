//
//  ChallengeCoordinatorProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/14/26.
//

import Foundation

/// Challenge Feature의 기능 인터페이스
protocol ChallengeCoordinatorProtocol: AnyObject {
    // Navigation
    func showDetail(id: Int)
    func showPost(id: Int)
    func showCreate()
    func showReport(id: Int)
    func showEditFeed(entity: FeedEntity)
    
    /// 공통 모달  표시
    func showModal(title: String, content: String, confirmButtonTitle: String, onConfirm: @escaping () -> Void)

    // Report & Block
    func showReportFeedPopup(feedId: Int, confirmAction: (() -> Void)?)
    func showReportUserPopup(userId: Int, challengeId: Int, confirmAction: (() -> Void)?)
    func showReportUserSheet(onReportUser: (() -> Void)?, onBlockUser: (() -> Void)?)
    
    
    func closeSheet()

    // Popup Control
    func closePopup()

    // Navigation Control
    func close()
}
