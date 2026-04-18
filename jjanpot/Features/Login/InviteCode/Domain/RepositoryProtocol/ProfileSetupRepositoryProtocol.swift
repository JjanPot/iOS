//
//  ProfileSetupRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//

import Foundation


protocol ProfileSetupRepositoryProtocol {
    func setProfile(nickname: String, birthDate: String?, imageUrl: String?) async throws -> SetProfileEntity
    func getPresignedUrl(directory: String, contentType: String) async throws -> PresignedURLEntity
    
    func uploadImageToS3(imageData: Data, presignedUrl: String) async throws
    func updateToken(user: SetProfileEntity)
}
