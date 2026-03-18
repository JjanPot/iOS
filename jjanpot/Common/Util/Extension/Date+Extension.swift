//
//  Date+Extension.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//

import Foundation

extension Date {
    public enum LocaleType {
        /// en_US_POSIX (기본값, ISO 8601 표준)
        case us

        /// ko_KR (한국어 요일, 월 이름)
        case kr

        var locale: Locale {
            switch self {
            case .us:
                return Locale(identifier: "en_US_POSIX")
            case .kr:
                return Locale(identifier: "ko_KR")
            }
        }
    }
}


extension Date {
    public enum DateFormat: String {
        
        /// "yyyy-MM-dd'T'HH:mm:ss"
        case iso8601 = "yyyy-MM-dd'T'HH:mm:ss"
        
        /// "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case iso8601WithMilliseconds = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        /// "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        case iso8601WithMicroseconds = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        /// "yyyy-MM-dd'T'HH:mm:ss'Z'"
        case iso8601UTC = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        /// "yyyy-MM-dd HH:mm:ss"
        case dateTime = "yyyy-MM-dd HH:mm:ss"
        
        /// "yyyy-MM-dd"
        case dateOnly = "yyyy-MM-dd"
        
    }
}
