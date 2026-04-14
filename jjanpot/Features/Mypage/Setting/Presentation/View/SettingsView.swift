//
//  SetttingsView.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import SwiftUI

struct SettingsView: View {
    enum WebDestination {
        case useOfService
        case privacyPolicy
        case marketingTemrs
        case useGuide
    }
    
    @ObservedObject private var authManager = AuthManager.shared
    @StateObject var viewModel: SettingsViewModel
    private let coordinator: MyPageCoordinatorProtocol

    @State var webDestination: WebDestination?
    @State var isShowLogoutPopup: Bool = false
    @State var isShowSignoutPopup: Bool = false

    init(viewModel: SettingsViewModel, coordinator: MyPageCoordinatorProtocol) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                
                if authManager.isLoggedIn {
                    MenuSection("앱 설정") {
                        MenuButton("알림 설정") {
                            coordinator.showAlarmSettings()
                        }
                    }
                }
                
                MenuSection("법적 정보 및 앱 정보") {
                    MenuButton("서비스 이용약관") { webDestination = .useOfService}
                    MenuButton("개인정보처리방침") { webDestination = .privacyPolicy }
                    MenuButton("마케팅 수신 동의 약관") { webDestination = .marketingTemrs }
                }
                
                MenuSection("도움말") {
                    MenuButton("이용가이드 / FAQ") { webDestination = .useGuide }
                }
                
                if authManager.isLoggedIn {
                    MenuSection("계정") {
                        MenuButton("로그아웃") {
                            isShowLogoutPopup = true
                        }
                        MenuButton("탈퇴하기") {
                            isShowSignoutPopup = true
                        }
                    }
                }
                
                Spacer()
                
            } // ~VStack
            .padding(20)
        } // ~ScrollView
        .navigationTitle("설정")
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
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
                        viewModel.withdraw()
                        isShowSignoutPopup = false
                    }
                    ModalButton(title: "함께하기") {
                        isShowSignoutPopup = false
                    }
                }
        }
        .fullScreenCover(isPresented: Binding(get: { webDestination != nil},
                                              set: { if !$0 { webDestination = nil}}
                                             ))
        {
            webContent
            
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    @ViewBuilder
    private var webContent: some View {
        switch webDestination {
        case .useOfService:
            WebView(url: AppConstants.URLs.termsOfService, onDismiss: { webDestination = nil })
            
        case .privacyPolicy:
            WebView(url: AppConstants.URLs.privacyPolicy, onDismiss: { webDestination = nil })
            
        case .marketingTemrs:
            WebView(url: AppConstants.URLs.marketingTemrs, onDismiss: { webDestination = nil })
            
        case .useGuide:
            WebView(url: AppConstants.URLs.useGuide, onDismiss: { webDestination = nil })
            
        case .none:
            EmptyView()
        }
    }
}

//#Preview {
//    let di = MockMainDIContainer()
//    di.makeSettingsView(coordinator: di.makeAppCoordinator())
//}
