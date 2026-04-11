//
//  AppConstants.swift
//  jjanpot
//
//  Created by 임주희 on 3/24/26.
//

import Foundation

enum AppConstants {

    // MARK: - URLs

    enum URLs {
        /// 이용약관
        static let termsOfService = "https://patch-carpenter-1ef.notion.site/323cf10cd2e780fb923de53f35730547?source=copy_link"
        /// 개인정보 처리방침
        static let privacyPolicy = "https://patch-carpenter-1ef.notion.site/323cf10cd2e780dbae46f69761e835ea?source=copy_link"
        
        /// 오픈소스라이선스
        static let openSourceLicense = "https://patch-carpenter-1ef.notion.site/32dcf10cd2e78081a7a3c18daa24edcf?source=copy_link"
        
        /// 마케팅 수신 활용
        static let marketingTemrs = "https://patch-carpenter-1ef.notion.site/32dcf10cd2e7800ab06ddd5b40e35110?source=copy_link"
        
        /// 이용가이드
        static let useGuide = "https://patch-carpenter-1ef.notion.site/JJANPOT-FAQ-32fcf10cd2e780cab8efe04e712cc180?source=copy_link"
        
        /// 의견남기기
        static let contactUs = "https://tally.so/r/LZYNlG"
        
    }

    // MARK: - App Info

    enum AppInfo {
        static let appNameKr = "짠팟"
        static let appNameEn = "jjanpot"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    // MARK: - UI

//    enum UI {
//        static let animationDuration: TimeInterval = 0.3
//        static let cornerRadius: CGFloat = 12
//    }
}
