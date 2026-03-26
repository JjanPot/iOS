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
        
        /// "yyyy.MM.dd"
        case dateOnly2 = "yyyy.MM.dd"
        
        /// "yy.MM.dd"
        case simpleDateOnly = "yy.MM.dd"
    }
}

extension Date {
    /// Date를 지정된 형식의 문자열로 변환
    /// - Parameters:
    ///   - format: 날짜 형식 (예: "yyyy-MM-dd'T'HH:mm:ss")
    ///   - timeZone: 타임존 (기본값: 현재 타임존)
    ///   - locale: 로케일 (기본값: .posix)
    /// - Returns: 형식화된 날짜 문자열
    /// - NOTE: 요일이나 월 이름을 한국어로 표시할 때는 locale: .korean 사용하기
    public func toString(format: String,
                         timeZone: TimeZone = .current,
                         locale: LocaleType = .us) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale.locale
        return formatter.string(from: self)
    }
    
    
    /// 프리셋 형식을 사용하여 Date를 문자열로 변환
    /// - Parameters:
    ///   - format: 미리 정의된 날짜 형식 (DateFormat enum)
    ///   - timeZone: 타임존 (기본값: 현재 타임존)
    ///   - locale: 로케일 (기본값: .posix)
    /// - Returns: 형식화된 날짜 문자열
    /// - NOTE: 요일이나 월 이름을 한국어로 표시할 때는 locale: .korean 사용하기
    public func toString(_ format: DateFormat,
                         timeZone: TimeZone = .current,
                         locale: LocaleType = .us) -> String {
        return toString(format: format.rawValue, timeZone: timeZone, locale: locale)
    }
}
