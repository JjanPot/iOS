//
//  ReportFeedReason.swift
//  jjanpot
//
//  Created by 임주희 on 4/11/26.
//


enum ReportFeedReason: String, ReportReasonProtocol {
    /*
     INAPPROPRIATE_BEHAVIOR: 부적절한 행동
     SPAM_OR_ADVERTISEMENT: 스팸 또는 광고성 활동
     FRAUD_OR_FALSE_INFORMATION: 사기 또는 허위 정보 유포
     HARASSMENT_OR_DEFAMATION: 괴롭힘 또는 비방
     PRIVACY_VIOLATION: 개인정보 침해
     ETC: 기타 사유
     */
    case inappropriateBehavior
    case spamOrAdvertisement
    case fraudOrFalseInformation
    case harassmentOrDefamation
    case privacyViolation
    case etc
    
    var title: String {
        switch self {
        case .inappropriateBehavior: "부적절한 콘텐츠(욕설, 음란물, 혐오 등)예요."
        case .spamOrAdvertisement: "스팸 또는 광고성 글이에요."
        case .fraudOrFalseInformation: "사기 또는 허위 정보 글이에요."
        case .harassmentOrDefamation: "괴롭힘 또는 비방 글이에요."
        case .privacyViolation: "개인정보 침해 글이에요."
        case .etc: "기타 사유예요."
            
            
        }
    }
    var popupTitle: String {
        "게시글을 신고하는 이유가 무엇인가요?"
    }
    
    var code: String {
        switch self {
        case .inappropriateBehavior: "INAPPROPRIATE_BEHAVIOR"
        case .spamOrAdvertisement: "SPAM_OR_ADVERTISEMENT"
        case .fraudOrFalseInformation: "FRAUD_OR_FALSE_INFORMATION"
        case .harassmentOrDefamation: "HARASSMENT_OR_DEFAMATION"
        case .privacyViolation: "PRIVACY_VIOLATION"
        case .etc: "ETC"
        }
    }
}

enum ReportUserReason: String, ReportReasonProtocol{
    /*
     INAPPROPRIATE_BEHAVIOR: 부적절한 행동
     SPAM_OR_ADVERTISEMENT: 스팸 또는 광고성 활동
     FRAUD_OR_FALSE_INFORMATION: 사기 또는 허위 정보 유포
     HARASSMENT_OR_DEFAMATION: 괴롭힘 또는 비방
     PRIVACY_VIOLATION: 개인정보 침해
     ETC: 기타 사유
     */
    case inappropriateBehavior
    case spamOrAdvertisement
    case fraudOrFalseInformation
    case harassmentOrDefamation
    case privacyViolation
    case etc
    
    var title: String {
        switch self {
        case .inappropriateBehavior: "부적절한 행동을 하는 사용자예요."
        case .spamOrAdvertisement: "스팸 또는 광고성 활동을 하는 사용자예요."
        case .fraudOrFalseInformation: "사기 또는 허위 정보를 유포하는 사용자예요"
        case .harassmentOrDefamation: "괴롭힘 또는 비방을 하는 사용자예요."
        case .privacyViolation: "개인정보 침해하는 사용자예요."
        case .etc: "기타 사유의 사용자예요."
        }
    }
    
    var popupTitle: String {
        "사용자를 신고하는 이유가 무엇인가요?"
    }
    
    var code: String {
        switch self {
        case .inappropriateBehavior: "INAPPROPRIATE_BEHAVIOR"
        case .spamOrAdvertisement: "SPAM_OR_ADVERTISEMENT"
        case .fraudOrFalseInformation: "FRAUD_OR_FALSE_INFORMATION"
        case .harassmentOrDefamation: "HARASSMENT_OR_DEFAMATION"
        case .privacyViolation: "PRIVACY_VIOLATION"
        case .etc: "ETC"
        }
        
    }
}
