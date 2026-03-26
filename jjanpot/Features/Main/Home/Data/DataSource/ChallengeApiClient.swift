//
//  ChallengeApiClient.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//

import Foundation
import Alamofire

enum ChallengeRouter {
    // 챌린지 조회 (홈화면)
    case getChallenges
    
    // 팀,개인 절약현황 조회 (홈화면)
    case getChallengeSummary(challengeId: Int)
}
extension ChallengeRouter: Router {
    var baseURL: URL {
        URL(string: NetworkConfig.baseURL)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getChallenges, .getChallengeSummary:
                .get
        
        }
    }
    
    var path: String {
        switch self {
        case .getChallenges:
                return "/api/challenges/v1/current"
        case .getChallengeSummary:
            return "/api/challenges/v1/{id}/stats"
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var parameters: Parameters? {
        switch self {
        case .getChallenges:
                return nil
            
        case let .getChallengeSummary(id):
            let params: Parameters = [
                "id" : id,
            ]
            return params
        }
    }
    
    var encoding: Encoding? {
        nil
    }
    
    
}

// MARK: - ChallengeApiClient

protocol ChallengeApiClientProtocol {
    
    /// 챌린지 조회 (홈화면)
    func fetchChallenges() async -> Result<ChallengeResponseDto, NetworkError>
    
    /// 팀,개인 절약현황 조회 (홈화면)
    func fetchChallengeSummary(challengeId: Int) async -> Result<ChallengeSummaryDto, NetworkError>
    
}
final class ChallengeApiClient: ApiClient<ChallengeRouter>, ChallengeApiClientProtocol {
    func fetchChallenges() async -> Result<ChallengeResponseDto, NetworkError> {
        await request(.getChallenges)
    }
    
    func fetchChallengeSummary(challengeId: Int) async -> Result<ChallengeSummaryDto, NetworkError> {
        await request(.getChallengeSummary(challengeId: challengeId))
    }
}
