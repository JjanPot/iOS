//
//  NetworkConfig.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation

public enum NetworkConfig {
    
    public static var environment: NetworkEnvironment {
        #if DEBUG
        return .dev
        #else
        return .prod
        #endif
    }

    public static var baseURL: String {
        switch environment {
        case .dev:
            "https://jjanpot.shop"
        case .prod:
            "https://jjanpot.shop/"
        }
    }
}
