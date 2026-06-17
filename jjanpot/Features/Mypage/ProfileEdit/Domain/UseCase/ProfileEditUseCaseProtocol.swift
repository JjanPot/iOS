//
//  ProfileEditUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 5/10/26.
//

import Foundation
import UIKit


protocol ProfileEditUseCaseProtocol {
    func getUserInfo() async throws -> UserEntity
    func setProfile(nickname: String, birthDate: String?, image: UIImage?) async throws -> UserEntity
}

struct ProfileEditUseCase: ProfileEditUseCaseProtocol {
    private let repository: ProfileEditRepositoryProtocol
    init(repository: ProfileEditRepositoryProtocol) {
        self.repository = repository
    }
    
    func getUserInfo() async throws -> UserEntity {
        guard isLoggedIn() else {
            throw NetworkError.cancelled
        }
        return try await repository.getUserInfo()
    }
    
    private func isLoggedIn() -> Bool {
        repository.isLoggedIn()
    }
    
    func setProfile(nickname: String, birthDate: String?, image: UIImage?) async throws -> UserEntity {
        
        // 이미지 업로드
        let imageUrl: String? = try await uplpadImage(image: image, directory: "profile/", contentType: "image/jpeg")
        
        // 프로필 등록
        return try await repository.setProfile(nickname: nickname, birthDate: birthDate, imageUrl: imageUrl)
    }
    
    private func uplpadImage(image: UIImage?, directory: String, contentType: String) async throws  -> String? {
        guard let image else { return nil }
        // 이미지를 JPEG 데이터로 변환
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw FileManagerError.imageConversionFailed
        }
        
        // presignedUrl 받기
        let entity = try await repository.getPresignedUrl(directory: directory, contentType: contentType)
        
        // S3에 이미지 업로드
        try await repository.uploadImageToS3(
            imageData: imageData,
            presignedUrl: entity.uploadUrl
        )
        return entity.imageUrl
    }
}
