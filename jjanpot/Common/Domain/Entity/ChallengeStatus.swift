//
//  ChallengeStatus.swift
//  jjanpot
//
//  Created by 임주희 on 4/19/26.
//



enum ChallengeStatus {
    /// 없음
    case none
    
    /// 대기중
    case waiting
    
    /// 챌린지 진행중
    case inProgress
}


struct ChallengeStatusMapper {
    func map(from status: String) -> ChallengeStatus {
        switch status {
        case "WAITING", "대기중인 챌린지": return .waiting
        case "ONGOING", "진행중인 챌린지": return .inProgress
        default: return .none
            
        }
    }
}
/*
 enum ChallengeStatus: String, Codable {
     case waiting = "WAITING"
     case ongoing = "ONGOING"
     case none = "NONE"
 }
 */
