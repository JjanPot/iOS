//
//  AuthRouter.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation
import Alamofire

public enum AuthRouter {
    // 소셜 로그인
    case kakaoLogin(accessToken: String, deviceUuid: String, fcmToken: String?)
    case appleLogin(accessToken: String, deviceUuid: String, fcmToken: String?)
    case googleLogin(accessToken: String, deviceUuid: String, fcmToken: String?)
    
    // 토큰 재발급
    case refresh(token: String)
    
    // 약관동의
    case agreement(marketingConsentAgreed: Bool)
    
    // 프로필 설정  birthDate "2000-01-15"
    case setProfile(nickname: String, birthDate: String?, imageUrl: String?)
    
    // MARK : mypage
    
    /// 로그아웃
    case logout(userId: Int)
}

extension AuthRouter: Router {
   
    public var baseURL: URL {
        URL(string: NetworkConfig.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .appleLogin:
            return "api/auth/v1/login/apple"
        case .googleLogin:
            return "api/auth/v1/login/google"
        case .kakaoLogin:
            return "api/auth/v1/login/kakao"
            
            
        case .refresh:
            return "api/auth/v1/refresh"
        case .agreement:
            return "/api/users/v1/onboarding/agreement"
            
        case .setProfile:
            return "/api/users/v1/onboarding/profile"
            
        case .logout:
            return "/api/auth/v1/logout"
        }
    }
    
    public var method: HTTPMethod {
        return .post
    }
    
    public var parameters: Parameters? {
        switch self {
        case let .kakaoLogin(token, deviceUuid, fcmToken):
            let params: Parameters = [
                "accessToken" : token,
                "deviceUuid" : deviceUuid,
                "fcmToken" : fcmToken,
            ]
            return params
           
        case let .appleLogin(token, deviceUuid, fcmToken):
            let params: Parameters = [
                "accessToken" : token,
                "deviceUuid" : deviceUuid,
                "fcmToken" : fcmToken,
            ]
            return params
            
        case let .googleLogin(token, deviceUuid, fcmToken):
            let params: Parameters = [
                "accessToken" : token,
                "deviceUuid" : deviceUuid,
                "fcmToken" : fcmToken,
            ]
            return params
            
        case let .refresh(token):
            let params: Parameters = [
                "refreshToken" : token,
            ]
            return params
            
        case let .agreement(marketing):
            let params: Parameters = [
                "ageVerified" : true,
                "termsOfServiceAgreed" : true,
                "privacyPolicyAgreed" : true,
                "marketingConsent" : marketing,
            ]
            return params
            
        case let .setProfile(nickname, birthDate, imageUrl):
            var params: Parameters = [
                "nickname" : nickname,
            ]
            if let birthDate {
                params["birthDate"] = birthDate
            }
            if let imageUrl {
                params["profileImageUrl"] = imageUrl
            }
            return params
            
        case let .logout(userId):
            let params: Parameters = [
                "userId" : userId,
            ]
            return params
            
        }
    }
    
    public var headers: HTTPHeaders? {
        return [
            "Accept" : "application/json",
            "Content-Type" : "application/json",
        ]
    }

    public var body: Encodable? {
        return nil
    }

    public var encoding: Encoding? {
        nil
    }

}
    

// MARK: - API Client Protocol

public protocol AuthApiClientProtocol {
    func kakaoLogin(accessToken: String, deviceUuid: String, fcmToken: String?) async -> Result<LoginResponseDto, NetworkError>
    func appleLogin(accessToken: String, deviceUuid: String, fcmToken: String?) async -> Result<LoginResponseDto, NetworkError>
    func googleLogin(accessToken: String, deviceUuid: String, fcmToken: String?) async -> Result<LoginResponseDto, NetworkError>
    
    /// 토큰 재발급
    func refreshToken(refreshToken token: String) async -> Result<RefreshDto, NetworkError>

    /// 약관 동의
    func agreement(marketingConsentAgreed: Bool) async -> Result<EmptyResponseDto, NetworkError>
    
    /// 프로필 설정
    func setProfile(nickname: String, birthDate: String?, imageUrl: String?) async -> Result<SetProfileDto, NetworkError>
    
    /// 로그아웃
    func logout(userId: Int) async -> Result<EmptyResponseDto, NetworkError>
    
}


// MARK: - API Client

public class AuthApiClient: ApiClient<AuthRouter>, AuthApiClientProtocol {
   
    public func appleLogin(accessToken token: String, deviceUuid uuid: String, fcmToken: String?) async -> Result<LoginResponseDto, NetworkError> {
        await request(AuthRouter.appleLogin(accessToken: token, deviceUuid: uuid, fcmToken: fcmToken))
    }
    public func kakaoLogin(accessToken token: String, deviceUuid uuid: String, fcmToken: String?) async -> Result<LoginResponseDto, NetworkError> {
        await request(AuthRouter.kakaoLogin(accessToken: token, deviceUuid: uuid, fcmToken: fcmToken))
    }
    public func googleLogin(accessToken token: String, deviceUuid uuid: String, fcmToken: String?) async -> Result<LoginResponseDto, NetworkError> {
        await request(AuthRouter.googleLogin(accessToken: token, deviceUuid: uuid, fcmToken: fcmToken))
    }
    
    // 토큰 재발급
    public func refreshToken(refreshToken token: String) async -> Result<RefreshDto, NetworkError> {
        await request(.refresh(token: token))
    }
    
    /// 약관 동의
    public func agreement(marketingConsentAgreed: Bool) async -> Result<EmptyResponseDto, NetworkError> {
        await request(.agreement(marketingConsentAgreed: marketingConsentAgreed))
    }
    
    /// 프로필 설정
    public func setProfile(nickname: String, birthDate: String?, imageUrl: String?) async -> Result<SetProfileDto, NetworkError> {
        await request(.setProfile(nickname: nickname, birthDate: birthDate, imageUrl: imageUrl))
    }
    
    /// 로그아웃
    public func logout(userId: Int) async -> Result<EmptyResponseDto, NetworkError> {
        await request(.logout(userId: userId))
    }
}
