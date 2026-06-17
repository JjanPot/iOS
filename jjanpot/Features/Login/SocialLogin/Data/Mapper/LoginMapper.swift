//
//  LoginMapper.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation

struct LoginMapper {
    static func toEntity(from dto: LoginResponseDto) -> LoginEntity? {
        let nextOnboardingStep: LoginEntity.NextStep
        switch dto.nextOnboardingStep {
        case .agreement:
            nextOnboardingStep = .agreement
        case .profile:
            nextOnboardingStep = .profile
        case .completed:
            nextOnboardingStep = .completed
        }
        
        return LoginEntity(
            user: UserEntity(
                userId: dto.user.userId,
                nickname: dto.user.nickname,
                imageUrl: nil,
                birthDate: nil
            ),
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
            
            nextOnboardingStep: nextOnboardingStep,
            isReviewMode: dto.reviewMode
        )
    }
}
