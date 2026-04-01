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
    case kakaoLogin(accessToken: String)
    case appleLogin(accessToken: String)
    case googleLogin(accessToken: String)
    
    // 토큰 재발급
    case refresh(token: String)
    
    // 약관동의
    case agreement(marketingConsentAgreed: Bool)
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
        }
    }
    
    public var method: HTTPMethod {
        return .post
    }
    
    public var parameters: Parameters? {
        switch self {
        case let .kakaoLogin(token):
            let params: Parameters = [
                "accessToken" : token,
            ]
            return params
           
        case let .appleLogin(token):
            let params: Parameters = [
                "accessToken" : token,
            ]
            return params
            
        case let .googleLogin(token):
            let params: Parameters = [
                "accessToken" : token,
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
    func kakaoLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError>
    func appleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError>
    func googleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError>
    
    /// 토큰 재발급
    func refreshToken(refreshToken token: String) async -> Result<RefreshDto, NetworkError>

    /// 약관 동의
    func agreement(marketingConsentAgreed: Bool) async -> Result<EmptyResponseDto, NetworkError>
}


// MARK: - API Client

public class AuthApiClient: ApiClient<AuthRouter>, AuthApiClientProtocol {
   
    
    public func appleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError> {
        await request(AuthRouter.appleLogin(accessToken: token))
    }
    public func kakaoLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError> {
        await request(AuthRouter.kakaoLogin(accessToken: token))
    }
    public func googleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError> {
        await request(AuthRouter.googleLogin(accessToken: token))
    }
    
    // 토큰 재발급
    public func refreshToken(refreshToken token: String) async -> Result<RefreshDto, NetworkError> {
        await request(.refresh(token: token))
    }
    
    /// 약관 동의
    public func agreement(marketingConsentAgreed: Bool) async -> Result<EmptyResponseDto, NetworkError> {
        await request(.agreement(marketingConsentAgreed: marketingConsentAgreed))
    }
}
