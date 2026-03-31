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
    
    // 챌린지 상세정보
    case getDetail(id: Int)
    
    /// 초대코드 입력
    case submitInviteCode(inviteCode: String)
    
    /// 카테고리 조회
    case getCategories
    
    /// 피드 조회
    case getFeed(challengeId: Int)
}
extension ChallengeRouter: Router {
    var baseURL: URL {
        URL(string: NetworkConfig.baseURL)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getChallenges,
                .getChallengeSummary,
                .getCategories,
                .getDetail,
                .getFeed
            : .get
            
        case .createChallenge,
                .submitInviteCode
            : .post
        
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
            
        case let .getDetail(id):
            return "/api/challenges/v1/\(id)/detail"
            
        case .submitInviteCode:
            return "/api/users/v1/onboarding/invite-code"
            
        case let .getFeed(id):
            return "/api/certifications/v1/challenge/\(id)"
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var parameters: Parameters? {
        switch self {
        case .getChallenges,
             .getChallengeSummary,
             .getCategories,
                .getDetail,
                .getFeed
            : return nil
            
        case .createChallenge:
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
            
            
        case let .submitInviteCode(code):
            let params: Parameters = [
                "inviteCode" : code,
            ]
            return params
        }
    }

    var body: Encodable? {
        switch self {
        case .getChallenges,
             .getChallengeSummary,
             .getCategories,
             .getDetail,
             .submitInviteCode,
             .getFeed
            :return nil

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
    func fetchCategories() async -> Result<[SavingCategoryDto], NetworkError>

    /// 챌린지 생성
    func createChallenge(dto: CreateChallengeRequestDto) async -> Result<CreateChallengeResponseDto, NetworkError>
    
    /// 챌린지 상세
    func fetchDetail(challengeId: Int) async -> Result<ChallengeDetailResponseDto, NetworkError>
    
    /// 초대 코드 입력
    func submitInviteCode(code: String) async -> Result<SubmitInviteCodeResponseDto, NetworkError>

}

final class ChallengeApiClient: ApiClient<ChallengeRouter>, ChallengeApiClientProtocol {
    func fetchChallenges() async -> Result<ChallengeResponseDto, NetworkError> {
        await request(.getChallenges)
    }

    func fetchChallengeSummary(challengeId: Int) async -> Result<ChallengeSummaryDto, NetworkError> {
        await request(.getChallengeSummary(challengeId: challengeId))
    }

    func fetchCategories() async -> Result<[SavingCategoryDto], NetworkError> {
        await request(.getCategories)
    }

    func createChallenge(dto: CreateChallengeRequestDto) async -> Result<CreateChallengeResponseDto, NetworkError> {
        await request(.createChallenge(dto: dto))
    }
    
    
    func fetchDetail(challengeId: Int) async -> Result<ChallengeDetailResponseDto, NetworkError>{
        await request(.getDetail(id: challengeId))
    }
    
    /// 초대 코드 입력
    func submitInviteCode(code: String) async -> Result<SubmitInviteCodeResponseDto, NetworkError>{
        await request(.submitInviteCode(inviteCode: code))
    }
}
