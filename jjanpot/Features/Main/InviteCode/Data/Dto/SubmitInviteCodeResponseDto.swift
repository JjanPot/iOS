//
//  SubmitInviteCodeResponseDto.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


struct SubmitInviteCodeResponseDto: Codable {
    let teamId: Int
    let teamName: String?
    let teamType: String
    let challengeId: Int
    let currentMemberCount, maxMemberCount: Int
    
    enum CodingKeys: String, CodingKey {
        case teamId
        case teamName, teamType, currentMemberCount, maxMemberCount
        case challengeId
    }
}
