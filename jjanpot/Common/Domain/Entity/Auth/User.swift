//
//  User.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation

/// 사용자 정보 Entity
struct UserEntity: Codable {
    let userId: Int
    let nickname: String
    
    init(userId: Int, nickname: String) {
        self.userId = userId
        self.nickname = nickname
    }
}
