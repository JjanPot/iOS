//
//  ProfileEditUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 5/10/26.
//

import Foundation
import UIKit

// 프로필 수정
enum ProfileImageUpdateAction {
    case keep              // 기존 이미지 유지
    case upload(Data)   // 새 이미지 업로드
    case delete            // 기존 이미지 삭제
}

protocol ProfileEditUseCaseProtocol {
    func getUserInfo() async throws -> UserEntity
    func setProfile(nickname: String, birthDate: Date?, profileImageAction: ProfileImageUpdateAction) async throws -> UserEntity
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
    
    
    /// 프로필 설정
    /// - Parameters:
    ///   - nickname: 닉네임
    ///   - birthDate: 생년월일 "yyyy-MM-dd"
    ///   - image: ui이미지가 있으면 로컬 이미지 업로드
    func setProfile(nickname: String, birthDate: Date?, profileImageAction: ProfileImageUpdateAction) async throws -> UserEntity {
        
        // 생년월일 "yyyy-MM-dd"
        let date = birthDate?.toString(.dateOnly)
        
        switch profileImageAction {
        case .keep: // 유지
            print(">>>>> 11 이미지 유지")
            return try await repository.setProfile(nickname: nickname, birthDate: date, imageUrl: nil, shouldDeleteProfileImage: false)
            
        case let .upload(image): // 이미지 업로드
            print(">>>>> 22 이미지 업로드")
            let imageUrl: String? = try await uplpadImage(imageData: image, directory: "profile/", contentType: "image/jpeg")
            return try await repository.setProfile(nickname: nickname, birthDate: date, imageUrl: imageUrl, shouldDeleteProfileImage: false)
            
        case .delete: // 기존 이미지 삭제
            print(">>>>> 33 기존 이미지 삭제")
            return try await repository.setProfile(nickname: nickname, birthDate: date, imageUrl: nil, shouldDeleteProfileImage: true)
        }
    }
    
    private func uplpadImage(imageData: Data?, directory: String, contentType: String) async throws  -> String? {
        guard let imageData else { return nil }
//        // 이미지를 JPEG 데이터로 변환
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//            throw FileManagerError.imageConversionFailed
//        }
        
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
