//
//  ChallengeApiClient.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//

import Foundation
import Alamofire
import UIKit

enum ChallengeRouter {
    // 챌린지 조회 (홈화면)
    case getChallenges
    
    // 팀,개인 절약현황 조회 (홈화면)
    case getChallengeSummary(challengeId: Int)
    
    // 챌린지 생성
    case createChallenge(dto: CreateChallengeRequestDto)
    
    // 챌린지 취소
    case deleteChallenge(challengeId: Int)
    
    // 챌린지 상세정보
    case getDetail(id: Int)
    
    /// 초대코드 입력
    case submitInviteCode(inviteCode: String)
    
    /// 카테고리 조회
    case getCategories
    
    /// 피드 조회
    case fetchFeed(challengeId: Int)

    /// 챌린지 인증
    case postChallenge
    
    /// 챌린지 오버뷰 가져오기
    case fetchChallengeOverview(challengeId: Int)
    
    /// mypage 챌린지 통계 조회
    case getChallengeStats
    
    case getChallengeReport(challengeId: Int)
    
    case getChallengeHistory
    
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
                .fetchFeed,
                .fetchChallengeOverview,
                .getChallengeStats,
                .getChallengeReport,
                .getChallengeHistory
            : .get

        case .createChallenge,
                .submitInviteCode,
                .postChallenge,
                .deleteChallenge
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

        case let .fetchFeed(id):
            return "/api/certifications/v1/challenge/\(id)"

        case .postChallenge:
            return "/api/certifications/v1"

        case let .fetchChallengeOverview(id):
            return "/api/challenges/v1/\(id)/members"
            
        case let .deleteChallenge(id):
            return "/api/challenges/v1/\(id)/cancel"
            
        case .getChallengeStats:
            return "/api/users/v1/challenge-stats"
            
        case let .getChallengeReport(id):
            return "/api/challenges/v1/\(id)/result"
            
        case .getChallengeHistory:
            return "/api/challenges/v1/history"
            
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .postChallenge:
            // multipart upload는 Alamofire가 자동으로 Content-Type 설정
            return [ "Accept" : "application/json"]
        default:
            return [ "Accept" : "application/json",
                "Content-Type" : "application/json"]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getChallenges,
             .getChallengeSummary,
             .getCategories,
                .getDetail,
                .fetchFeed,
                .createChallenge,
                .postChallenge,
                .fetchChallengeOverview,
                .deleteChallenge,
                .getChallengeStats,
                .getChallengeReport,
                .getChallengeHistory
            : return nil
        


        case let .submitInviteCode(code):
            let params: Parameters = [
                "inviteCode" : code,
            ]
            return params
        }
    }

    var body: Encodable? {
        switch self {
        case let .createChallenge(dto):
            return dto
        case .postChallenge:
            // upload() 메서드에서 별도로 처리하므로 body는 nil
            return nil

        default: return nil
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

    /// 챌린지 인증 (이미지 포함)
    func postChallenge(dto: ChallengePostRequestDto, imageData: Data?) async -> Result<EmptyResponseDto, NetworkError>
    
    
    /// 챌린지 오버뷰 가져오기
    func fetchChallengeOverview(challengeId: Int) async -> Result<OverviewDto, NetworkError>
    
    /// 챌린지 피드 가져오기
    func fetchFeed(challengeId: Int) async -> Result <[FeedResponseDto],NetworkError>
    
    /// 챌린지 취소하기
    func deleteChallenge(challengeId: Int) async -> Result<EmptyResponseDto, NetworkError>
    
    /// mypage 챌린지 통계 조회
    func getChallengeStats() async -> Result<ChallengeStatsDto, NetworkError>
    
    /// 챌린지 결과 조회
    func getChallengeReport(challengeId: Int) async -> Result<ChallengeReportDto, NetworkError>
    
    /// 완료된 챌린지 보기
    func getChallengeHistory() async -> Result<[ChallengeHistoryDto], NetworkError>

}

    // MARK: - ChallengeApiClient

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

    /// 챌린지 인증
    func postChallenge(dto: ChallengePostRequestDto, imageData: Data?) async -> Result<EmptyResponseDto, NetworkError> {
        await upload(.postChallenge, body: dto, imageData: imageData)
    }
    
    /// 챌린지 오버뷰 가져오기
    func fetchChallengeOverview(challengeId: Int) async -> Result<OverviewDto, NetworkError> {
        await request(.fetchChallengeOverview(challengeId: challengeId))
    }
    
    /// 챌린지 피드 가져오기
    func fetchFeed(challengeId: Int) async -> Result <[FeedResponseDto],NetworkError> {
        await request(.fetchFeed(challengeId: challengeId))
    }
    
    /// 챌린지 취소하기
    func deleteChallenge(challengeId: Int) async -> Result<EmptyResponseDto, NetworkError>{
        await request(.deleteChallenge(challengeId: challengeId))
    }
    
    /// mypage 챌린지 통계 조회
    func getChallengeStats() async -> Result<ChallengeStatsDto, NetworkError> {
        await request(.getChallengeStats)
    }
    
    /// 챌린지 결과 조회
    func getChallengeReport(challengeId: Int) async -> Result<ChallengeReportDto, NetworkError> {
        await request(.getChallengeReport(challengeId: challengeId))
    }
    
    /// 완료된 챌린지 보기
    func getChallengeHistory() async -> Result<[ChallengeHistoryDto], NetworkError> {
        await request(.getChallengeHistory)
    }
}
