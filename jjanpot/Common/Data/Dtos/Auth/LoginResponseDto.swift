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
    
    // 토큰
    let accessToken: String
    let refreshToken: String
    
    
    // 신규가입 (true이면 온보딩 미완료 → 온보딩 화면으로 이동)
    let newUser: Bool
    // 약관 동의 완료 여부
    let termsAgreed: Bool
    // 온보딩 완료 여부
    let onboardingCompleted: Bool
    
    // 다음 온보딩 단계 (AGREEMENT, PROFILE, COMPLETED)
    // 그냥 이거로 분기 태우면 된다고 함. (termsAgreed, onboardingCompleted, newUser 는 신경쓰지 않고)
    let nextOnboardingStep: NextStep
    
    // 리뷰용 변수, true이면 앱 심사 계정 → 심사용 버튼 노출
    let reviewMode: Bool
    
    enum NextStep: String, Codable {
        case agreement = "AGREEMENT"
        case profile = "PROFILE"
        case completed = "COMPLETED"
    }
}
public struct UserDto: Codable {
    let userId: Int
    let nickname: String
}
