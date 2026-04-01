//
//  ChallengePostRequestDto.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//

import Foundation

// 지출(SPEND): spentAmount 필수, 절약 금액 = 기준 금액 - 소비 금액 (음수 가능)
// 무지출(NO_SPEND): spentAmount 불필요, (절약 금액 = 기준 금액 전액)


struct ChallengePostRequestDto: Encodable {
    let challengeId: Int
    let spendType: String
    let categoryId: Int
    let spentAmount: Int?
    let memo: String
    /// "2026-03-29T10:30:00"
    let spentAt: String

    enum CodingKeys: String, CodingKey {
        case challengeId
        case spendType
        case categoryId
        case spentAmount
        case memo
        case spentAt
    }
}

extension ChallengePostRequestDto {
    init(from entity: ChallengePostRequestEntity){
        self.challengeId = entity.challengeId
        self.spendType = entity.spendType
        self.categoryId = entity.categoryId
        self.spentAmount = entity.spentAmount
        self.memo = entity.memo
        self.spentAt = entity.spentAt.toString(.iso8601)
    }
}
