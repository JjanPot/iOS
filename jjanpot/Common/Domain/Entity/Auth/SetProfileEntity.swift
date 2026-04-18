//
//  SetProfileEntity.swift
//  jjanpot
//
//  Created by 임주희 on 4/19/26.
//


struct SetProfileEntity {
    let profileImageURL: String
    let nickname: String
    let birthDate: String?
}

extension SetProfileEntity {
    init(from dto: SetProfileDto) {
        self.profileImageURL = dto.profileImageURL
        self.nickname = dto.nickname
        self.birthDate = dto.birthDate
    }
}
