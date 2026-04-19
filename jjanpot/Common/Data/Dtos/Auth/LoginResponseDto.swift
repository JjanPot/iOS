//
//  LoginResponseDto.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


/// 소셜 로그인
public struct LoginResponseDto: Codable {
     
    // 유저정보
    let user: UserDto
    let newUser: Bool
    
    // 토큰
    let accessToken: String
    let refreshToken: String
    
    
    // 리뷰용 변수
    let reviewMode: Bool
}
public struct UserDto: Codable {
    let userId: Int
    let nickname: String
}
