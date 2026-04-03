//
//  SetttingsView.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    private let coordinator: MyPageCoordinator
    
    @State var isShowLogoutPopup: Bool = false
    @State var isShowSignoutPopup: Bool = false
    
    init(viewModel: SettingsViewModel, coordinator: MyPageCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                
                
                MenuSection("앱 설정") {
                    MenuButton("알림 설정") {}
                }
                MenuSection("법적 정보 및 앱 정보") {
                    MenuButton("서비스 이용약관") {}
                    MenuButton("개인정보처리방침") {}
                    MenuButton("운영 정책") {}
                    MenuButton("마케팅 수신 동의 약관") {}
                }
                MenuSection("도움말") {
                    MenuButton("이용가이드 / FAQ") {}
                }
                
                MenuSection("계정") {
                    MenuButton("로그아웃") {
                        isShowLogoutPopup = true
                    }
                    MenuButton("탈퇴하기") {
                        isShowSignoutPopup = true
                    }
                }
            } // ~VStack
        } // ~ScrollView
        .popup(isPresented: $isShowLogoutPopup) {
            Modal(title: "로그아웃 하시겠습니까?", content: "다시 로그인해야 서비스를 이용할 수 있어요.")
                .buttons {
                    ModalButton(title: "취소", colorType: .secondary) {
                        isShowLogoutPopup = false
                    }
                    ModalButton(title: "로그아웃") {
                        viewModel.logout()
                        isShowLogoutPopup = false
                    }
                }
        }
        .popup(isPresented: $isShowSignoutPopup) {
            Modal(title: "정말 탈퇴 하시겠습니까?", content: "탈퇴하면 계정은 삭제되어 복구되지 않습니다.")
                .buttons {
                    ModalButton(title: "탈퇴하기", colorType: .secondary) {
                        viewModel.signout()
                        isShowSignoutPopup = false
                    }
                    ModalButton(title: "함께하기") {
                        isShowSignoutPopup = false
                    }
                }
        }
    }
    
}

#Preview {
    let di = MockMyPageDIContainer()
    di.makeSettingsView(coordinator: di.makeMyPageCoordinator())
}

protocol SettingsRepositoryProtocol {
    func logout(userId: Int) async throws
}

struct SettingsRepository: SettingsRepositoryProtocol {
    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }
    
    func logout(userId: Int) async throws {
        let result = await authApiClient.logout(userId: userId)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}



protocol SettingsUseCaseProtocol {
    func logout() async throws
}
struct SettingsUseCase: SettingsUseCaseProtocol {
    private let repository: SettingsRepositoryProtocol
    init(repository: SettingsRepositoryProtocol) {
        self.repository = repository
    }
    
    func logout() async throws {
        guard let userId = getUserId() else {
            Logger.error("user id 못가져옴")
            throw NetworkError.requestFailed("userId is nil")
        }
        try await repository.logout(userId: userId)
        AuthManager.shared.logout()
    }
    
    private func getUserId() -> Int? {
        AuthManager.shared.currentUser?.userId
    }
}



import SwiftUI
import Combine
final class SettingsViewModel: ObservableObject {
    
    private let useCase: SettingsUseCaseProtocol
    init(useCase: SettingsUseCaseProtocol) {
        self.useCase = useCase
    }
    
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

                // [임시] 로그아웃 (로그인 NavigationStack으로 전환) 
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




