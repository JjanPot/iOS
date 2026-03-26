//
//  ChallengeSummaryDto.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


struct ChallengeSummaryDto: Codable {
    let team: Team
    let personal: Personal
    

    struct Team: Codable {
        // 인증평균
        let avgCertificationCount: Double
        // 참여율
        let participationRate : Int
        // 연속활동
        let consecutiveDays: Int
    }
    
    struct Personal: Codable {
        // 인증횟수
        let certificationCount: Int
        
        // 참여율
        let participationRate: Int
        // 연속활동
        let consecutiveDays: Int
    }
}
