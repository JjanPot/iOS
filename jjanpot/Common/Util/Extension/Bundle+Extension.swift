//
//  Bundle+Extension.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import Foundation

extension Bundle {
    /// Info.plist에서 특정 키의 값을 가져옵니다.
    func infoDictionary(for key: String) -> String {
        guard let value = self.infoDictionary?[key] as? String else {
            fatalError("\(key) not found in Info.plist")
        }
        return value
    }

    /// Kakao App Key
    var kakaoAppKey: String {
        return infoDictionary(for: "KAKAO_APP_KEY")
    }

    /// Google Client ID
    var googleClientID: String {
        return infoDictionary(for: "GOOGLE_CLIENT_ID")
    }
    
    /// Google admob ID
    var googleAdmobID: String {
        return infoDictionary(for: "GAD_APP_ID")
    }
}
