//
//  LoginEntity.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


struct LoginEntity {
    let userId: Int
    let socialType: LoginType
    
    // 유저정보
    let nickname: String?
    let profileImageUrl: String?
    
    // 토큰 정보
    let accessToken: String
    let refreshToken: String
    
}
