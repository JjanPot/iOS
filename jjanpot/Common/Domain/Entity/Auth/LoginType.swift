//
//  LoginType.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//

import Foundation

enum LoginType: String, Codable {
    case  kakao, google, apple
    
    init?(socialType: String) {
            self.init(rawValue: socialType.lowercased())
        }
}
