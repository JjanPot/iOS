//
//  LoginUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation

protocol LoginUseCaseProtocol {
    func loginWithApple() async throws -> LoginEntity
    func loginWithKakao() async throws -> LoginEntity
    func loginWithGoogle() async throws -> LoginEntity
    
    /// 로그인 성공 처리 (토큰 + 사용자 정보 저장)
    func login(entity: LoginEntity)
    
}
