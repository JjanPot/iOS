//
//  LoginMapper.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation

struct LoginMapper {
    static func toEntity(from dto: LoginResponseDto) -> LoginEntity? {
        return LoginEntity(
            user: UserEntity(
                userId: dto.user.userId,
                nickname: dto.user.nickname,
                imageUrl: nil,
                birthDate: nil
            ),
            isNewUser: dto.newUser,
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
            isReviewMode: dto.reviewMode
        )
    }
}
