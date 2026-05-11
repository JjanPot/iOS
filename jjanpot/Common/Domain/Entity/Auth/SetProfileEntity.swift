//
//  SetProfileEntity.swift
//  jjanpot
//
//  Created by 임주희 on 4/19/26.
//

import Foundation

struct SetProfileEntity {
    let profileImageURL: String
    let nickname: String
    let birthDate: Date?
}

extension SetProfileEntity {
    init(from dto: SetProfileDto) {
        self.profileImageURL = dto.profileImageURL
        self.nickname = dto.nickname
        // "2000-01-15",
        self.birthDate = dto.birthDate?.toDate(.dateOnly)
    }
}
