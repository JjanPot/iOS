//
//  LoginRepository.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation
import UIKit
import FirebaseCore
import FirebaseMessaging

struct LoginRepository: LoginRepositoryProtocol {
    
    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }
    
    // MARK: - socail loings..

    func kakaoLogin(accessToken token: String, deviceUuid uuid: String, fcmToken: String?) async -> Result<LoginEntity, NetworkError> {
        let result = await authApiClient.kakaoLogin(accessToken: token, deviceUuid: uuid, fcmToken: fcmToken)
        return mapToEntity(result)
    }

    func appleLogin(accessToken token: String, deviceUuid uuid: String, fcmToken: String?) async -> Result<LoginEntity, NetworkError> {
        let result = await authApiClient.appleLogin(accessToken: token, deviceUuid: uuid, fcmToken: fcmToken)
        return mapToEntity(result)
    }

    func googleLogin(accessToken token: String, deviceUuid uuid: String, fcmToken: String?) async -> Result<LoginEntity, NetworkError> {
        let result = await authApiClient.googleLogin(accessToken: token, deviceUuid: uuid, fcmToken: fcmToken)
        return mapToEntity(result)
    }
    
    
    func getUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    func getFcmToken() async -> String? {
        if let token = AuthManager.shared.getFcmToken() {
            return token
        }
        return try? await fetchFCMToken()
    }
    
    private func fetchFCMToken() async throws -> String? {
        try await Messaging.messaging().token()
    }
    
}

extension LoginRepository {
    private func mapToEntity(_ result: Result<LoginResponseDto, NetworkError>) -> Result<LoginEntity, NetworkError> {
        switch result {
        case .success(let dto):
            guard let entity = LoginMapper.toEntity(from: dto) else {
                return .failure(.failToDecode("Invalid socialType"))
            }
            return .success(entity)
        case .failure(let error):
            return .failure(error)
        }
    }
}
