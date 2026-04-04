//
//  ProfileDto.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import Foundation

public struct ProfileDto: Codable {
    let userId: Int
    let nickname: String
    let profileUrl: String?
    
    enum CodingKeys: CodingKey {
        case userId
        case nickname
        case profileUrl
    }
}
