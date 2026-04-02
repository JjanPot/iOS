//
//  RepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//

import Foundation

protocol LoginRepositoryProtocol {
    
    func kakaoLogin(accessToken token: String, deviceUuid uuid: String, fcmToken: String?) async -> Result<LoginEntity, NetworkError>
    func appleLogin(accessToken token: String, deviceUuid uuid: String, fcmToken: String?) async -> Result<LoginEntity, NetworkError>
    func googleLogin(accessToken token: String, deviceUuid uuid: String, fcmToken: String?) async -> Result<LoginEntity, NetworkError>
    
    
    func getUUID() -> String
    func getFcmToken() async -> String?
}
