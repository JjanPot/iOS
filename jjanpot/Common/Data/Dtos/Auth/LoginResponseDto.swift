//
//  LoginResponseDto.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


/// 소셜 로그인
public struct LoginResponseDto: Codable {
    let userId: Int
    let socialType: String
    
    // 유저정보
    let nickname: String?
    let profileImageUrl: String?
    
    // 토큰
    let accessToken: String
    let refreshToken: String
}
