//
//  User.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation

/// 사용자 정보 Entity
struct User: Codable {
    let userId: Int
    let nickname: String?
    let socialType: LoginType
    let profileImageUrl: String?

    init(userId: Int, nickname: String?, socialType: LoginType, profileImageUrl: String?) {
        self.userId = userId
        self.nickname = nickname
        self.socialType = socialType
        self.profileImageUrl = profileImageUrl
    }
}
