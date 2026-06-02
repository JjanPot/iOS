//
//  DeepLinkHandler.swift
//  jjanpot
//
//  Created by 임주희 on 6/2/26.
//

import Foundation
import Combine

class DeepLinkHandler: ObservableObject {
    static let shared = DeepLinkHandler()
    private init(){}
    
    @Published var destination: DeepLinkDestination?
    
    
    
    func handle(url: URL) {
        // Universal Link: https://jjanpot.shop/invite?code=aaaa
        // Custom Scheme:  jjanpot://invite?code=aaaa
        
        let isUniversal = url.host == "jjanpot.shop"
        let isCustom = url.scheme == "jjanpot"
        
        // 링크 유효성 확인
        guard isUniversal || isCustom else { return }
        Logger.debug("🔗 [DeepLink] open url: \(url)")
        
        
        let path = isUniversal ? url.path : "/\(url.host ?? "")"
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        print(">>>>> path: \(path)")
        print(">>>>> components: \(components)")
        
        
        switch path {
        case "/invite":
            guard let code = components?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
            destination = .invite(code: code)
            
        default:
            break
        }
    }
}

// MARK: - DeepLinkDestination

enum DeepLinkDestination: Equatable {
    case invite(code: String)
}
