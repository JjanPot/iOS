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
    
    /// 초대코드 입력 in onboarding
    case submitInviteCodeInOnboarding(inviteCode: String)
    
    /// 카테고리 조회
    case getCategories
    
    // MARK: review Mode
    
    /// 심사용 - 챌린지 즉시 시작
    case reviewMode_startChallenge(challengeId: Int)
    
    /// 심사용 - 챌린지 즉시 종료
    case reviewMode_finishChallenge(challengeId: Int)
    
    // MARK: 챌린지 대시보드
    
    /// 챌린지 오버뷰 가져오기
    case fetchChallengeOverview(challengeId: Int)
    
    /// 피드 조회
    case fetchFeed(challengeId: Int)

    /// 챌린지 인증
    case postChallenge
    
    /// 피드 수정
    case updateFeed(feedId: Int)
    
    /// 피드 삭제
    case deleteFeed(feedId: Int)
    
    /// 좋아요
    case likes(feedId: Int)
    
    
    
    // MARK: 챌린지 결과 조회
    
    /// mypage 챌린지 통계 조회
    case getChallengeStats
    
    case getChallengeReport(challengeId: Int)
    
    case getChallengeHistory
    
    // MARK: 신고하기
    
    /// 게시물 신고하기
    case reportFeed(feedId: Int, reason: String)
    
    /// 사용자 신고하기
    case reportUser(userId: Int, challengeId: Int, reason: String)
    
    /// 사용자 차단하기
    case blockUser(userId: Int, challengeId: Int)
    
    
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
                .submitInviteCodeInOnboarding,
                .postChallenge,
                .deleteChallenge,
                .reportFeed,
                .reportUser,
                .blockUser,
                .reviewMode_startChallenge,
                .reviewMode_finishChallenge,
                .likes
            : .post
            
        case .updateFeed:
                .put
            
        case .deleteFeed:
                .delete
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

        case .submitInviteCode, .submitInviteCodeInOnboarding:
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
            
        case .reportFeed:
            return "/api/reports/v1/certification"
            
        case .reportUser:
            return "/api/reports/v1/user"
            
        case .blockUser:
            return "/api/blocks/v1"
            
        case let .deleteFeed(feedId):
            return "/api/certifications/v1/\(feedId)"
            
        case let .updateFeed(feedId):
            return "/api/certifications/v1/\(feedId)"
            
        case let .reviewMode_startChallenge(challengeId):
            return "/api/auth/v1/review/challenge/\(challengeId)/start"
            
        case let .reviewMode_finishChallenge(challengeId):
            return "/api/auth/v1/review/challenge/\(challengeId)/finish"
            
        case let .likes(feedId):
            return "/api/certifications/v1/\(feedId)/likes"
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .postChallenge:
            // multipart upload는 Alamofire가 자동으로 Content-Type 설정
            return [ "Accept" : "application/json"]
            
            // 온보딩 헤더
            // 여기선 임시로 저장한 토큰을 보낸다.
        case .submitInviteCodeInOnboarding:
            var params: HTTPHeaders = [
                "Accept" : "application/json",
                "Content-Type" : "application/json",
            ]
            if let token = AuthManager.shared.getTempAccessToken() {
                params.add(name: "Authorization", value: "Bearer \(token)")
            }
            return params
            
        default:
            return nil
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
                .getChallengeHistory,
                .deleteFeed,
                .updateFeed,
                .reviewMode_startChallenge,
                .reviewMode_finishChallenge,
                .likes
            : return nil
        


        case let .submitInviteCode(code),
                let .submitInviteCodeInOnboarding(code):
            let params: Parameters = [
                "inviteCode" : code,
            ]
            return params
            
        case let .reportFeed(feedId, reason):
            let params: Parameters = [
                "certificationId" : feedId,
                "reason" : reason,
            ]
            return params
            
        case let .reportUser(userId, challengeId, reason):
            let params: Parameters = [
                "reportedUserId" : userId,
                "challengeId" : challengeId,
                "reason" : reason,
            ]
            return params
            
        case let .blockUser(userId, challengeId):
            let params: Parameters = [
                "blockedUserId" : userId,
                "challengeId" : challengeId,
            ]
            return params
        }
    }

    var body: Encodable? {
        switch self {
        case let .createChallenge(dto):
            return dto
        case .postChallenge, .updateFeed:
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
    
    /// 초대 코드 입력
    func submitInviteCodeInOnboarding(code: String) async -> Result<SubmitInviteCodeResponseDto, NetworkError>

    /// 챌린지 인증 (이미지 포함)
    func postChallenge(dto: FeedPostRequestDto, imageData: Data?) async -> Result<EmptyResponseDto, NetworkError>
    
    
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
    
    /// 게시물 신고하기
    func reportFeed(feedId: Int, reason: String) async -> Result<EmptyResponseDto, NetworkError>
    
    /// 사용자 신고하기
    func reportUser(userId: Int, challengeId: Int, reason: String) async -> Result<EmptyResponseDto, NetworkError>
    
    /// 사용자 차단하기
    func blockUser(userId: Int, challengeId: Int) async -> Result<EmptyResponseDto, NetworkError>
    
    /// 피드 삭제하기
    func deleteFeed(feedId: Int) async -> Result<EmptyResponseDto, NetworkError>
    
    /// 피드 수정하기
    /// - Parameters:
    ///   - feedId: feed Id
    ///   - dto: feed body
    ///   - imageData: 첨부된 이미지
    ///   - isDeleteImage: 기존 이미지 삭제 여부
    func updateFeed(feedId: Int, dto: FeedPostRequestDto, imageData: Data?, isDeleteImage: Bool) async -> Result<EmptyResponseDto, NetworkError>
    
    /// 심사용 - 챌린지 즉시 시작
    func reviewMode_startChallenge(challengeId: Int) async -> Result<EmptyResponseDto, NetworkError>
    
    /// 심사용 - 챌린지 즉시 종료
    func reviewMode_finishChallenge(challengeId: Int) async -> Result<EmptyResponseDto, NetworkError>
    
    /// 좋아요
    func likes(feedId: Int) async -> Result<LikesDto, NetworkError>

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
    
    /// 초대 코드 입력 (온보딩용)
    func submitInviteCodeInOnboarding(code: String) async -> Result<SubmitInviteCodeResponseDto, NetworkError>{
        await request(.submitInviteCodeInOnboarding(inviteCode: code))
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
    
    /// 게시물 신고하기
    func reportFeed(feedId: Int, reason: String) async -> Result<EmptyResponseDto, NetworkError> {
        await request(.reportFeed(feedId: feedId, reason: reason))
    }
    
    /// 사용자 신고하기
    func reportUser(userId: Int, challengeId: Int, reason: String) async -> Result<EmptyResponseDto, NetworkError>{
        await request(.reportUser(userId: userId, challengeId: challengeId, reason: reason))
    }
    
    /// 사용자 차단하기
    func blockUser(userId: Int, challengeId: Int) async -> Result<EmptyResponseDto, NetworkError>{
        await request(.blockUser(userId: userId, challengeId: challengeId))
    }
    
    /// 챌린지 인증
    func postChallenge(dto: FeedPostRequestDto, imageData: Data?) async -> Result<EmptyResponseDto, NetworkError> {
        await upload(.postChallenge, body: dto, imageData: imageData)
    }
    
    /// 피드 삭제하기
    func deleteFeed(feedId: Int) async -> Result<EmptyResponseDto, NetworkError>{
        await request(.deleteFeed(feedId: feedId))
    }
    
    /// 피드 수정하기
    func updateFeed(feedId: Int, dto: FeedPostRequestDto, imageData: Data?, isDeleteImage: Bool) async -> Result<EmptyResponseDto, NetworkError> {
        await upload(.updateFeed(feedId: feedId), body: dto, imageData: imageData, additionalFormFields: ["deleteImage": isDeleteImage])
    }
    
    /// 심사용 - 챌린지 즉시 시작
    func reviewMode_startChallenge(challengeId: Int) async -> Result<EmptyResponseDto, NetworkError> {
        await request(.reviewMode_startChallenge(challengeId: challengeId))
    }
    
    /// 심사용 - 챌린지 즉시 종료
    func reviewMode_finishChallenge(challengeId: Int) async -> Result<EmptyResponseDto, NetworkError> {
        await request(.reviewMode_finishChallenge(challengeId: challengeId))
    }
    
    /// 좋아요
    func likes(feedId: Int) async -> Result<LikesDto, NetworkError>  {
        await request(.likes(feedId: feedId))
    }
}
