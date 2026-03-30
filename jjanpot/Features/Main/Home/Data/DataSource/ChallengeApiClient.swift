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
    
    // 챌린지 생성
    case createChallenge(dto: CreateChallengeRequestDto)
    
    
    // 카테고리 조회
    case getCategories
}
extension ChallengeRouter: Router {
    var baseURL: URL {
        URL(string: NetworkConfig.baseURL)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getChallenges,
                .getChallengeSummary,
                .getCategories:
                .get
            
        case .createChallenge: .post
        
        }
    }
    
    var path: String {
        switch self {
        case .getChallenges:
                return "/api/challenges/v1/current"
        case let .getChallengeSummary(id):
            return "/api/challenges/v1/\(id)/stats"
        case .getCategories:
            return "/api/categories/v1"
            
        case .createChallenge:
            return "/api/challenges/v1"
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var parameters: Parameters? {
        switch self {
        case .getChallenges,
             .getChallengeSummary,
             .getCategories:
//             .createChallenge:
            return nil
            
        case .createChallenge(let dto):
//            return [
//                "title": dto.title,
//                "description": dto.description,
//                "teamType": dto.teamType,
//                "maxMemberCount": dto.maxMemberCount,
//                "startDate": dto.startDate,
//                "categories": dto.categories.map { ["categoryId": $0.id, "amount": $0.amount] },
//                "goalAmount": dto.goalAmount,
//                "minPersonalGoalAmount": dto.minPersonalGoalAmount]
            return nil
        }
    }

    var body: Encodable? {
        switch self {
        case .getChallenges,
             .getChallengeSummary,
             .getCategories:
            return nil

        case let .createChallenge(dto):
            return dto
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

    /// 카테고리 목록 불러오기
    func fetchCategories() async -> Result<[CategoryDto], NetworkError>

    /// 챌린지 생성
    func createChallenge(dto: CreateChallengeRequestDto) async -> Result<CreateChallengeResponseDto, NetworkError>

}
final class ChallengeApiClient: ApiClient<ChallengeRouter>, ChallengeApiClientProtocol {
    func fetchChallenges() async -> Result<ChallengeResponseDto, NetworkError> {
        await request(.getChallenges)
    }

    func fetchChallengeSummary(challengeId: Int) async -> Result<ChallengeSummaryDto, NetworkError> {
        await request(.getChallengeSummary(challengeId: challengeId))
    }

    func fetchCategories() async -> Result<[CategoryDto], NetworkError> {
        await request(.getCategories)
    }

    func createChallenge(dto: CreateChallengeRequestDto) async -> Result<CreateChallengeResponseDto, NetworkError> {
        await request(.createChallenge(dto: dto))
    }
}

struct CreateChallengeResponseDto: Codable {
}



struct CreateChallengeRequestDto: Codable {
    let title, description, teamType: String
    let maxMemberCount: Int
    
    /// "2026-03-18"
    let startDate: String
    let categories: [Category]
    
    let goalAmount, minPersonalGoalAmount: Int
    
    struct Category: Codable {
        let id: Int
        let amount: Int

        enum CodingKeys: String, CodingKey {
            case id = "categoryId"
            case amount
        }
    }

}

