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

@main
struct jjanpotApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    // App 레벨에서 네비게이션 상태 관리
    @StateObject private var appCoordinator = AppDIContainer.shared.makeAppCoordinator()
    private let container = AppDIContainer.shared

    init(){
        // Kakao SDK 초기화 (환경변수에서 가져옴)
        let kakaoAppKey = Bundle.main.kakaoAppKey
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }

    var body: some Scene {
        WindowGroup {
            // App 레벨에서 화면 분기 (Navigation Router 패턴)
            RootViewWithGlobalToast {
                Group {
                    switch appCoordinator.currentFlow {
                    case .launching:
                        // 스플래시 화면 (토큰 체크)
                        container.makeLaunchScreenView(appCoordinator: appCoordinator)
                        
                    case .login:
                        // 로그인 플로우 (독립적인 NavigationStack)
                        LoginNavigationStack {
                            // 로그인 성공 → 메인 화면으로 전환
                            appCoordinator.navigateToMain()
                        }
                        
                    case .main:
                        // 메인 플로우 (독립적인 NavigationStack)
                        container.makeMainNavigationStack()
                    }
                }
                // 인증 리디렉션 url 처리
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        AuthController.handleOpenUrl(url: url)
                    } else {
                        GIDSignIn.sharedInstance.handle(url)
                    }
                })
            }
        }
    }
}

