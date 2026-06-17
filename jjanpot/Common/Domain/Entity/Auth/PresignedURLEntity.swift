//
//  PresignedURLEntity.swift
//  jjanpot
//
//  Created by 임주희 on 5/10/26.
//

import Foundation

struct PresignedURLEntity {
    let uploadUrl: String
    let imageUrl: String
    
    init(from dto: PresignedURLDto) {
        self.uploadUrl = dto.uploadUrl
        self.imageUrl = dto.imageUrl
    }
}
