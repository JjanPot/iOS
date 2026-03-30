//
//  ChallengeResponseDTO.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation

struct ChallengeResponseDto: Codable {
    let status: ChallengeStatus
    let waiting: WaitingChallengeDto?
    let ongoing: OngoingChallengeDto?
}

enum ChallengeStatus: String, Codable {
    case waiting = "WAITING"
    case ongoing = "ONGOING"
    case none = "NONE"
}

// 대기중 챌린지 정보
struct WaitingChallengeDto: Codable {
    let challengeId: Int
    let title: String
    let challengeStatus: String
    let goalAmount: Int
    
    // "2026-07-21T00:00:00"
    let startDate: String
    let endDate: String
    let isLeader: Bool
    let inviteCode: String
}

// 진행중 챌린지 정보
struct OngoingChallengeDto: Codable {
    let challengeId: Int
    let title: String
    let challengeStatus: String
    /// "2026-07-21T00:00:00"
    let endDate: String
    let weekNumber: Int
    let weekGoalAmount: Int
    let teamWeekSavedAmount: Int
    let personalWeekSavedAmount: Int
    let achievementRate: Int
}
