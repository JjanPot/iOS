//
//  ProfileEditRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 5/10/26.
//

import Foundation

protocol ProfileEditRepositoryProtocol {
    func setProfile(nickname: String, birthDate: String?, imageUrl: String?, shouldDeleteProfileImage: Bool) async throws -> UserEntity
    
    func getPresignedUrl(directory: String, contentType: String) async throws -> PresignedURLEntity
    
    func uploadImageToS3(imageData: Data, presignedUrl: String) async throws
    
    func isLoggedIn () -> Bool
    
    /// 유저 정보 가져오기
    func getUserInfo() async throws -> UserEntity
}
