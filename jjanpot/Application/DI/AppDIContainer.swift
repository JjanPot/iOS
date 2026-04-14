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
    private lazy var challengeApiClient: ChallengeApiClientProtocol = {
        ChallengeApiClient(session: session)
    }()
    
    private lazy var launchScreenDIContainer: LaunchScreenDIContainer = {
        LaunchScreenDIContainer(
            authApiClient: authApiClient,
            appContainer: self
        )
    }()
    
    lazy var loginDIContainer: LoginDIContainerProtocol = {
        LoginDIContainer(authApiClient: authApiClient, challengeApiClient: challengeApiClient)
    }()

    lazy var mainDIContainer: MainDIContainerProtocol = {
        MainDIContainer(
            authApiClient: authApiClient,
            challengeApiClient: challengeApiClient
        )
    }()
}

// MARK: - App Navigation
extension AppDIContainer {
    func makeRootCoordinator() -> RootCoordinator {
        return RootCoordinator()
    }

    func makeAppCoordinator() -> AppCoordinator {
        return AppCoordinator(container: mainDIContainer)
    }
}


// MARK: - LaunchScreen Feature
extension AppDIContainer {
    func makeLaunchScreenView(appCoordinator: RootCoordinatorProtocol) -> LaunchScreenView {
        return launchScreenDIContainer.makeLaunchScreenView(appCoordinator: appCoordinator)
    }
}


// MARK: - Main Feature
extension AppDIContainer {
    func makeMainNavigationStack(appCoordinator: AppCoordinator) -> MainNavigationStack {
        return MainNavigationStack(container: mainDIContainer, appCoordinator: appCoordinator)
    }
}
