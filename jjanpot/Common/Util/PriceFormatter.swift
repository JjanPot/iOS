//
//  PriceFormatUtil.swift
//  jjanpot
//
//  Created by 임주희 on 4/18/26.
//

import Foundation

struct PriceFormatter {
    static func formatWon(_ value: Int) -> String {
        if value < 10_000 {
            return "\(value)원"
        }
        
        let man = value / 10_000
        let remainder = value % 10_000
        
        if remainder == 0 {
            return "\(man)만원"
        } else {
            let thousand = remainder / 1_000
            return "\(man)만\(thousand)천원"
        }
    }
}
