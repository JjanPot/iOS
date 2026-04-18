//
//  ProfileSetupRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//

import Foundation
import Alamofire

struct ProfileSetupRepository: ProfileSetupRepositoryProtocol {
    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    
    func setProfile(nickname: String, birthDate: String?, imageUrl: String?) async throws -> SetProfileEntity {
        let result = await authApiClient.setProfile(nickname: nickname, birthDate: birthDate, imageUrl: imageUrl)
        switch result {
        case let .success(dto):
            return SetProfileEntity(from: dto)
        case .failure(let error):
            throw error
        }
    }
    
    /// presignedUrl 가져오기
    func getPresignedUrl(directory: String, contentType: String) async throws -> PresignedURLEntity {
        let result = await authApiClient.presignedUrl(directory: directory, contentType: contentType)
        switch result {
        case .success(let dto):
            return PresignedURLEntity(from: dto)
        case .failure(let error):
            throw error
        }
    }
    
    /// S3에 이미지 업로드 (helper를 재사용)
    func uploadImageToS3(imageData: Data, presignedUrl: String) async throws {
        try await uploadImageToS3Helper(imageData: imageData, presignedUrl: presignedUrl)
    }
    
    /// S3에 이미지 업로드 (Private Helper)
    private func uploadImageToS3Helper(imageData: Data, presignedUrl: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(imageData, to: presignedUrl, method: .put, headers: ["Content-Type": "image/jpeg"])
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        Logger.success("S3에 이미지 업로드 성공")
                        continuation.resume()
                    case .failure(let error):
                        Logger.error("S3 이미지 업로드 실패: \(error)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    
    
    /// 임시토큰을 정식토큰으로 저장.
    /// - 최초로그인 > 약관동의 > 프로필 등록까지는 임시토큰으로 진행
    /// - 프로필등록 이후부터 회원가입 된 것
    /// - 프로필 등록 성공 후, 임시토큰을 정식 토큰으로 저장,
    func updateToken(user: SetProfileEntity){
        guard let tempAccessToken = AuthManager.shared.getTempAccessToken(),
              let tempRefreshToken = AuthManager.shared.getTempRefreshToken() else { return }
        
        let currentUser = AuthManager.shared.currentUser
        if let userId = currentUser?.userId {
            // 정식 로그인
            let newUser = UserEntity(
                userId: userId,
                nickname: user.nickname,
                imageUrl: user.profileImageURL
            )
            let loginEntity = LoginEntity(
                user: newUser,
                isNewUser: false,
                accessToken: tempAccessToken,
                refreshToken: tempRefreshToken
            )
            AuthManager.shared.login(loginEntity)
        } else {
            AuthManager.shared.refreshToken(
                accessToken: tempAccessToken,
                refreshToken: tempRefreshToken
            )
            AuthManager.shared.updateNickname(user.nickname)
        }
        
        // 임시 토큰 삭제
        AuthManager.shared.clearTempLogin()
    }
}

struct PresignedURLEntity {
    let uploadUrl: String
    let imageUrl: String
    
    init(from dto: PresignedURLDto) {
        self.uploadUrl = dto.uploadUrl
        self.imageUrl = dto.imageUrl
    }
}
