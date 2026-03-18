//
//  LoginMapper.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation

struct LoginMapper {
    static func toEntity(from dto: LoginResponseDto) -> LoginEntity? {
        guard let socialType = LoginType(socialType: dto.socialType) else {
            return nil
        }

        return LoginEntity(
            userId: dto.userId,
            socialType: socialType,
            nickname: dto.nickname,
            profileImageUrl: dto.profileImageUrl,
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
        )
    }
}
