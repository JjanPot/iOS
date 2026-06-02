//
//  jjanpotApp.swift
//  jjanpot
//
//  Created by 임주희 on 3/11/26.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn
import GoogleMobileAds

@main
struct jjanpotApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    // App 레벨에서 네비게이션 상태 관리
    @StateObject private var rootCoordinator = AppDIContainer.shared.makeRootCoordinator()
    @StateObject private var appCoordinator = AppDIContainer.shared.makeAppCoordinator()
    private let container = AppDIContainer.shared

    init(){
        // Kakao SDK 초기화 (환경변수에서 가져옴)
        let kakaoAppKey = Bundle.main.kakaoAppKey
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        
        // 애드몹 초기화 (Initialize the Google Mobile Ads SDK.)
        MobileAds.shared.start()    
    }

    var body: some Scene {
        WindowGroup {
            // App 레벨에서 화면 분기 (Navigation Router 패턴)
            RootViewWithGlobalToast {
                Group {
                    switch rootCoordinator.currentFlow {
                    case .launching:
                        // 스플래시 화면 (토큰 체크)
                        container.makeLaunchScreenView(appCoordinator: rootCoordinator)

                    case .login:
                        // 로그인 플로우 (독립적인 NavigationStack)
                        LoginNavigationStack {
                            // 로그인 성공 → 메인 화면으로 전환
                            rootCoordinator.navigateToMain()
                        }

                    case .main:
                        // 메인 플로우 (독립적인 NavigationStack)
                        container.makeMainNavigationStack(appCoordinator: appCoordinator)
                    }
                }
                // URL 처리 (딥링크, 인증 리디렉션 등)
                .onOpenURL(perform: { url in
                    // 커스텀 딥링크 또는 Universal Link 처리
                    if url.scheme == "jjanpot" || url.host == "jjanpot.shop" {
                        DeepLinkHandler.shared.handle(url: url)
                    }
                    // 카카오 로그인
                    else if AuthApi.isKakaoTalkLoginUrl(url) {
                        AuthController.handleOpenUrl(url: url)
                    }
                    // 구글 로그인
                    else {
                        GIDSignIn.sharedInstance.handle(url)
                    }
                })
                // 로그아웃 notification 수신
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("userDidLogout"))) { _ in
                    rootCoordinator.navigateToLogin()
                }
            }
        }
    }
}

