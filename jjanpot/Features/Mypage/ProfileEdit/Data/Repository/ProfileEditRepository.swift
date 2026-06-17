//
//  ProfileEditRepository.swift
//  jjanpot
//
//  Created by 임주희 on 5/10/26.
//

import Foundation
import Alamofire

struct ProfileEditRepository: ProfileEditRepositoryProtocol {
    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    func setProfile(nickname: String, birthDate: String?, imageUrl: String?) async throws -> UserEntity {
        let result = await authApiClient.editProfile(nickname: nickname, birthDate: birthDate, imageUrl: imageUrl)
        switch result {
        case let .success(dto):
            return UserEntity(from: dto)
            
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
    
    func isLoggedIn () -> Bool {
        AuthManager.shared.isLoggedIn
    }
    
    // 유저 정보 가져오기
    func getUserInfo() async throws -> UserEntity {
        let result = await authApiClient.getProfile()
        switch result {
        case let .success(dto):
            return UserEntity(from: dto)
            
        case let .failure(error):
            throw error
        }
    }    
}
