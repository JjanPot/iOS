//
//  ProfileSetupUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//

import Foundation
import UIKit

protocol ProfileSetupUseCaseProtocol {
    func setProfile(nickname: String, birthDate: String?, image: UIImage?) async throws
}
struct ProfileSetupUseCase: ProfileSetupUseCaseProtocol {
    private let repository: ProfileSetupRepositoryProtocol
    init(repository: ProfileSetupRepositoryProtocol) {
        self.repository = repository
    }
    
    
    func setProfile(nickname: String, birthDate: String?, image: UIImage?) async throws {
        
        // 이미지 업로드
        let imageUrl: String? = try await uplpadImage(image: image, directory: "profile/", contentType: "image/jpeg")
        
        // 프로필 등록
        let user = try await repository.setProfile(nickname: nickname, birthDate: birthDate, imageUrl: imageUrl)
        
        // 성공한 경우, 임시로그인에서 제대로 로그인 시키기.
        repository.updateToken(user: user)
    }
    
    
    func uplpadImage(image: UIImage?, directory: String, contentType: String) async throws  -> String? {
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




enum FileManagerError: LocalizedError {
    case documentsDirectoryNotFound
    case imageConversionFailed
    

    var errorDescription: String? {
        switch self {
        case .documentsDirectoryNotFound:
            return "Documents 디렉토리를 찾을 수 없습니다."
        case .imageConversionFailed:
            return "이미지를 JPEG 형식으로 변환하는데 실패했습니다."
        }
    }
}
