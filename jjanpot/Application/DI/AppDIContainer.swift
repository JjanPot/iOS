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
    
    lazy var loginDIContainer: LoginDIContainerProtocol = {
        LoginDIContainer(authApiClient: authApiClient)
    }()
}

// MARK: - App Navigation
extension AppDIContainer {
    func makeAppCoordinator() -> AppCoordinator {
        return AppCoordinator()
    }
}


// MARK: - LaunchScreen Feature
extension AppDIContainer {
    func makeLaunchScreenView(appCoordinator: AppCoordinator) -> LaunchScreenView {
        return launchScreenDIContainer.makeLaunchScreenView(appCoordinator: appCoordinator)
    }
}


// MARK: - Login Feature
extension AppDIContainer {

    func makeTermsView(coordinator: LoginCoordinator) -> TermsView {
        return TermsView(coordinator: coordinator)
    }
}

// MARK: - Main Feature
extension AppDIContainer {

    func makeMainTabView() -> MainTabView {
        return MainTabView()
    }
    
    func makeInviteCodeView() -> some View {
        // TODO: InviteCodeView 구현 필요
        Text("InviteCodeView (구현 예정)")
    }
}
