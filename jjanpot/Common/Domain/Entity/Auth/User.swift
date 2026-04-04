//
//  User.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation

/// 사용자 정보 Entity
struct UserEntity {
    let userId: Int
    let nickname: String
    let imageUrl: String?
}

extension UserEntity {
    init(from dto: ProfileDto) {
        self.userId = dto.userId
        self.nickname = dto.nickname
        self.imageUrl = dto.profileUrl
    }
}
