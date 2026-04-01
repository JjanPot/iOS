//
//  OverviewDto.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//


import Foundation

struct OverviewDto: Codable {
    let challengeId: Int
    let title: String
    let startDate: String //"2026-03-25T00:00:00",
    
    let totalSavedAmount: Int
    let goalAmount: Int
    
    let members: [Member]
    
    enum CodingKeys: String, CodingKey {
        case challengeId
        case title, startDate, totalSavedAmount, goalAmount, members
    }
    
    // MARK: - Member
    struct Member: Codable {
        let userId: Int
        let nickname: String
        let profileImageURL: String
        let savedAmount: Int
        let isMe: Bool
        
        enum CodingKeys: String, CodingKey {
            case userId
            case nickname
            case profileImageURL = "profileImageUrl"
            case savedAmount, isMe
        }
    }
}
