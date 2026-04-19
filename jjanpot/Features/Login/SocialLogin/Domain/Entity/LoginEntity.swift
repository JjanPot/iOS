//
//  LoginEntity.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


struct LoginEntity {
    
    // 유저정보
    let user: UserEntity
    let isNewUser: Bool
    
    // 토큰 정보
    let accessToken: String
    let refreshToken: String
    
    let isReviewMode: Bool
}
