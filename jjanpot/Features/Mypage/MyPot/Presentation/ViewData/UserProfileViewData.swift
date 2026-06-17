//
//  UserProfileViewData.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


struct UserProfileViewData {
    let userId: Int
    let nickname: String
    let imageUrl: String?
}

extension UserProfileViewData {
    init(from entity: UserEntity) {
        self.userId = entity.userId
        self.nickname = entity.nickname
        self.imageUrl = entity.imageUrl
    }
}