//
//  MainDestination.swift
//  jjanpot
//
//  Created by 임주희 on 4/14/26.
//

import Foundation
import SwiftUI

enum MainDestination: Route {
    case createChallenge
    case challengeDetail(id: Int)
    case feedPost(id: Int)
    // MyPage destinations
    case settings
    case profileEdit
    case alarmSettings
    case challengeReport(id: Int)
    case challengeHistory
    case feedEditFeed(challengeId: Int, entity: FeedEntity)
    case postImageDetail(imageUrl: String)

    var id: String {
        switch self {
        case .createChallenge:
            return "createChallenge"
        case .challengeDetail:
            return "challengeDetail"
        case .feedPost:
            return "feedPost"
        case .settings:
            return "settings"
        case .alarmSettings:
            return "alarmSettings"
        case .challengeReport:
            return "challengeReport"
        case .challengeHistory:
            return "challengeHistory"
        case .feedEditFeed:
            return "FeedEditFeed"
        case .postImageDetail:
            return "postImageDetail"
        case .profileEdit:
            return "profileEdit"
        }
    }

    var analyticsName: String {
        switch self {
        case .createChallenge:
            return "main_create_challenge"
        case .challengeDetail:
            return "challenge_detail"
        case .feedPost:
            return "feedPost"
        case .settings:
            return "settings"
        case .alarmSettings:
            return "alarm_settings"
        case .challengeReport:
            return "challenge_report"
        case .challengeHistory:
            return "challengeHistory"
        case .feedEditFeed:
            return "feedEditFeed"
        case .postImageDetail:
            return "postImageDetail"
        case .profileEdit:
            return "profileEdit"
        }
    }

    var hidesTabBar: Bool {
        switch self {
        case .createChallenge:
            return true
        case .challengeDetail, .feedPost, .settings, .alarmSettings, .challengeReport,
                .challengeHistory, .feedEditFeed, .postImageDetail, .profileEdit:
            return true
        }
    }
}

// MARK: - MainPopupDestination

enum MainPopupDestination {
    case login
    case inviteCode_Input
    case inviteCode_Copy(inviteCode: String)

    /// 챌린지 결과있음 팝업
    case reportPopup(challengeId: Int)

    /// 게시물 신고
    case reportFeedReason(feedId: Int, confirmAction: (()->Void)?)
    
    /// 유저 신고
    case reportUserReason(userId: Int, challengeId: Int, confirmAction: (()->Void)?)

    /// 공통모달
    case modal(modal: AnyView)
}

// MARK: - MainSheetDestination

enum MainSheetDestination {
    case reportUser(onReportUser: (()->Void)?, onBlockUser: (()->Void)?)
    
    
    // sheet 크기 조절
    var presentationDetents: Set<PresentationDetent> {
        switch self {
        case .reportUser: [.height(200)]
        }
    }
    
    // 손잡이 여부
    var presentationDragIndicator: Visibility {
        switch self {
        case .reportUser: .hidden
        }
    }
}
