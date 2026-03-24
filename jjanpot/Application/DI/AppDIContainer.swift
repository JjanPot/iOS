//
//  AppDIContainer.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import SwiftUI
import Alamofire

/// 앱 전체의 의존성을 관리하고 View를 생성하는 컨테이너
final class AppDIContainer {
    
    // MARK: - Singleton
    
    static let shared = AppDIContainer()
    
    private init() {}
    
    // MARK: - Network Dependencies
    
    private lazy var session: Session = {
        let factory = SessionFactory()
        #if DEBUG
        return factory.makeSession(for: .dev)
        #else
        return factory.makeSession(for: .prod)
        #endif
    }()
    
    private lazy var authApiClient: AuthApiClientProtocol = {
        AuthApiClient(session: session)
    }()
    
    private lazy var launchScreenDIContainer: LaunchScreenDIContainer = {
        LaunchScreenDIContainer(
            authApiClient: authApiClient,
            appContainer: self
        )
    }()
    
    private lazy var loginDIContainer: LoginDIContainer = {
        LoginDIContainer(authApiClient: authApiClient)
    }()
}


// MARK: - LaunchScreen Feature
extension AppDIContainer {
    func makeLaunchScreenView() -> LaunchScreenView {
        return launchScreenDIContainer.makeLaunchScreenView()
    }
}
    
// MARK: - Login Feature
extension AppDIContainer {

    func makeLoginView(onDismiss: @escaping () -> Void) -> LoginView {
        return loginDIContainer.makeLoginView(onDismiss: onDismiss, appContainer: self)
    }

    func makeTermsView() -> TermsView {
        return TermsView(diContainer: loginDIContainer)
    }
}

// MARK: - Main Feature
extension AppDIContainer {

    func makeMainTabView() -> MainTabView {
        return MainTabView()
    }
}
