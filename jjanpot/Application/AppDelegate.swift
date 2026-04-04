//
//  AppDelegate.swift
//  jjanpot
//
//  Created by 임주희 on 3/17/26.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseMessaging

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
        /*
         let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
         */

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Firebase에 device token 등록
#if DEBUG
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #else
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
#endif
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
        // 여기서 받은 FCM 토큰을 서버에 전달해주어야함
        Task {
            AuthManager.shared.updateFcm(token: fcmToken)
        }
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}


