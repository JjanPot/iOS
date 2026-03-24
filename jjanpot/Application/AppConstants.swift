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
        static let termsOfService = "https://patch-carpenter-1ef.notion.site/32dcf10cd2e780b8bebdd7c733c2bd1d?source=copy_link"
        /// 개인정보 처리방침
        static let privacyPolicy = "https://patch-carpenter-1ef.notion.site/32dcf10cd2e780ef9d2adb9315ab37bf?source=copy_link"
        
        /// 오픈소스라이선스
        static let openSourceLicense = "https://patch-carpenter-1ef.notion.site/32dcf10cd2e78081a7a3c18daa24edcf?source=copy_link"
        
        /// 마케팅 수신 활용
        static let marketingTemrs = "https://patch-carpenter-1ef.notion.site/32dcf10cd2e7800ab06ddd5b40e35110?source=copy_link"
        
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
