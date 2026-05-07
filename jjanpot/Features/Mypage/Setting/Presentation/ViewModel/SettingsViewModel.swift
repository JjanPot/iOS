//
//  SettingsViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


import SwiftUI
import Combine
final class SettingsViewModel: ObservableObject {
    
    private let useCase: SettingsUseCaseProtocol
    init(useCase: SettingsUseCaseProtocol) {
        self.useCase = useCase
    }
    private var originSettinValue: NotificationEntity?
    
    @Published var dailyEnabled: Bool = false
    @Published var weeklyEnabled: Bool = false
    @Published var marketingConsent: Bool = false
    
    
    @Published var isLogouted: Bool = false
    @Published var isLoading = false
    @Published var toastMessage: String?
    
    
    
    @MainActor
    func logout(){
        isLoading = true
        isLogouted = false
        Task {
            do {
                try await useCase.logout()
                Logger.success("로그아웃 성공")
                ToastManager.shared.show("로그아웃 되었습니다.")
                isLogouted = true
                
                // TODO: [임시] 로그아웃 (로그인 NavigationStack으로 전환)
                NotificationCenter.default.post(name: NSNotification.Name("userDidLogout"), object: nil)
            } catch {
                Logger.error("로그아웃 실패 \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
    
    /// 회원탈퇴
    @MainActor
    func withdraw(){
        isLoading = true
        isLogouted = false
        Task {
            do {
                try await useCase.withdraw()
                Logger.success("회원 탈퇴 성공")
                ToastManager.shared.show("회원 탈퇴 되었습니다.")
                isLogouted = true
                
                // TODO: [임시] 로그아웃 (로그인 NavigationStack으로 전환)
                NotificationCenter.default.post(name: NSNotification.Name("userDidLogout"), object: nil)
            } catch {
                Logger.error("회원 탈퇴 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    Logger.error("회원 탈퇴 실패: \(networkError.description)")
                    if networkError.isUserFacing {
                        toastMessage = networkError.description
                    }
                } else {
                    toastMessage = "회원 탈퇴 실패"
                }
            }
            isLoading = false
        }
    }
    
    // 알림 설정
    func setNotificationSettings() {
        isLoading = true
        Task {
            do {
                let entity = NotificationEntity(
                    dailyEnabled: dailyEnabled,
                    weeklyEnabled: weeklyEnabled,
                    marketingConsent: marketingConsent
                )
                
                // 기존 값과 다를 때만 업데이트
                guard entity != originSettinValue else {
                    isLoading = false
                    return
                }
                
                try await useCase.setNotificationSettings(setting: entity)
            } catch {
                Logger.error("알림 설정 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    Logger.error("알림 설정 실패: \(networkError.description)")
                    if networkError.isUserFacing {
                        toastMessage = networkError.description
                    }
                } else {
                    toastMessage = "설정 실패"
                }
            }
            isLoading = false
        }
    }
    
    // 알림 설정 가져오기
    func getNotificationSettings() {
        isLoading = true
        Task {
            do {
                let entity = try await useCase.getNotificationSettings()
                
                // 원본값 저장
                originSettinValue = entity
                
                // 뷰에 값 넣어주기
                dailyEnabled = entity.dailyEnabled
                weeklyEnabled = entity.weeklyEnabled
                marketingConsent = entity.marketingConsent
                
                
            } catch {
                Logger.error("알림 설정 불러오기 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    Logger.error("알림 설정 불러오기 실패: \(networkError.description)")
                    if networkError.isUserFacing {
                        toastMessage = networkError.description
                    }
                } else {
                    toastMessage = "불러오기 실패"
                }
            }
            isLoading = false
        }
    }
}
