//
//  jjanpotApp.swift
//  jjanpot
//
//  Created by 임주희 on 3/11/26.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct jjanpotApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init(){
        // Kakao SDK 초기화 (환경변수에서 가져옴)
        let kakaoAppKey = Bundle.main.kakaoAppKey
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            AppDIContainer.shared.makeLoginView(onDismiss: {})
            // 인증 리디렉션 url 처리
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        AuthController.handleOpenUrl(url: url)
                    } else {
                        //GIDSignIn.sharedInstance.handle(url)
                    }
                })
        }
    }
}

