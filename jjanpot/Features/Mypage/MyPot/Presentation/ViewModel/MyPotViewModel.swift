//
//  MyPotViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


import SwiftUI
import Combine
final class MyPotViewModel: ObservableObject {
    
    
    @Published var isLogouted: Bool = false
    @Published var isLoading = false
    @Published var toastMessage: String?
    
    
    private let useCase: MyPotUseCaseProtocol
    init(useCase: MyPotUseCaseProtocol) {
        self.useCase = useCase
    }
    
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

                // 로그아웃 성공 알림 전송
                NotificationCenter.default.post(name: NSNotification.Name("userDidLogout"), object: nil)
            } catch {
                Logger.error("로그아웃 실패 \(error.localizedDescription)")
            }
            isLoading = false

        }


    }
    func signout(){
        
    }
}
