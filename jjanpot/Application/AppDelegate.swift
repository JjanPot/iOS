//
//  AppDelegate.swift
//  jjanpot
//
//  Created by 임주희 on 3/17/26.
//

import Foundation
import SwiftUI
import FirebaseCore
@preconcurrency import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // 앱 실행 시, 사용자에게 알림허용 권한 받기
        UNUserNotificationCenter.current().delegate = self
        //메세지 대리자 설정
        Messaging.messaging().delegate = self

        
        // 원격 알림 등록 - 애플리케이션이 시작될 때 또는 적절한 시점에 원격 알림에 앱을 등록합니다.
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if granted {
                    Logger.success("✅ [AppDelegate] 알림 권한 허용됨")
                    DispatchQueue.main.async {
                        print("🔧 [AppDelegate] registerForRemoteNotifications 호출 중...")
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    Logger.error("❌ [AppDelegate] 알림 권한 거부됨")
                    if let error = error {
                        print("   에러: \(error.localizedDescription)")
                    }
                }
            }
        )

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        Logger.success("✅ [AppDelegate] APNS 토큰 받음: \(token)")

        // Firebase에 device token 등록
        Messaging.messaging().apnsToken = deviceToken
        
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.error("❌ [AppDelegate] 원격 알림 등록 실패: \(error.localizedDescription)")
        Logger.error("   에러 코드: \(error._code)")
    }
    
    // MARK: - 포그라운드 진입 시 토큰 갱신
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 로그인 상태이면 토큰 갱신 시도
        if AuthManager.shared.isLoggedIn {
            TokenRefreshService.shared.refreshToken { success in
                if success {
                    Logger.info("포그라운드 진입 시 토큰 갱신 성공")
                } else {
                    Logger.info("포그라운드 진입 시 토큰 갱신 실패 (로그아웃 처리)")
                }
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 앱이 활성화 되어있을 때 푸시를 받은 경우 호출되는 메서드
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        // let userInfo = notification.request.content.userInfo
        return [[.banner, .sound]]
    }
    
    
    // 푸시를 클릭해서 앱으로 들어왔을 때 호출되는 메서드
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        // 여기서 딥링크 구현
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        // FCM 토큰이 갱신됐을 때 호출되는 메서드
        if let token = fcmToken {
            Logger.success("✅ [AppDelegate] FCM 토큰 받음: \(token)")
            // 여기서 받은 FCM 토큰을 서버에 전달해주어야함
            Task {
                AuthManager.shared.updateFcm(token: fcmToken)
            }
        } else {
            Logger.error("⚠️  [AppDelegate] FCM 토큰이 nil입니다")
        }

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}


