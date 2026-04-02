//
//  SetProfileDto.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


public struct SetProfileDto: Codable {
    let profileImageURL: String
    let nickname, birthDate: String

    enum CodingKeys: String, CodingKey {
        case profileImageURL = "profileImageUrl"
        case nickname, birthDate
    }
}
