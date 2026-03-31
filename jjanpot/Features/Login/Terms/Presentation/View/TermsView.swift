//
//  TermsView.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import Foundation
import SwiftUI

struct TermsView: View {

    @StateObject var viewModel: TermsViewModel
    private let coordinator: LoginCoordinator

    @State private var allChecked = false
    @State private var ageAgreed = false
    @State private var termsAgreed = false
    @State private var privacyAgreed = false
    @State private var marketingAgreed = false

    /// 이용약관 띄우기(웹뷰)
    @State private var showTermsOfService: Bool = false

    /// 개인정보처리방침  띄우기(웹뷰)
    @State private var showPrivacyPolicy: Bool = false

    /// 마케팅 수신동의약관  띄우기(웹뷰)
    @State private var showMarketingTemrs: Bool = false

    init(viewModel: TermsViewModel, coordinator: LoginCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }


    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("서비스 이용을 위해\n이용약관 동의가 필요해요")
                .multilineTextAlignment(.leading)
                .font(.pretendard(.semiBold), size: 24)
                .padding(20)

            CheckBoxGroup(
                allChecked: $allChecked,
                items: [
                    CheckBoxItem(isChecked: $ageAgreed, label: "만 14세 이상입니다. (필수)"),
                    CheckBoxItem(isChecked: $termsAgreed, label: "서비스 이용약관 동의 (필수)",
                                 buttonText: "보기",
                                 action: {
                                     print("서비스 이용약관 동의 보기")
                                     showTermsOfService = true
                                 }),
                    CheckBoxItem(isChecked: $privacyAgreed, label: "개인정보 수집 및 이용 동의 (필수)",
                                 buttonText: "보기",
                                 action: {
                                     print("개인정보 수집 및 이용 동의 보기")
                                     showPrivacyPolicy = true
                                 }),
                    CheckBoxItem(isChecked: $marketingAgreed, label: "마케팅 정보 수신 동의 (선택)",
                                 buttonText: "보기",
                                 action: {
                                     print("마케팅 수신 동의")
                                     showMarketingTemrs = true
                                 })
                ],
                allLabel: "약관에 모두 동의합니다."
            )
            .padding(20)

            Spacer()

            MainButton(title: "다음", size: .large, colorType: .fill, isDisabled: !(ageAgreed && termsAgreed && privacyAgreed)) {
                viewModel.agreeTerms(marketingAgreed: marketingAgreed)
            }
            .padding()
        }
        .navigationTitle("이용약관")
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .fullScreenCover(isPresented: $showTermsOfService) {
            coordinator.makeWebView(url: AppConstants.URLs.termsOfService) {
                showTermsOfService = false
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showPrivacyPolicy) {
            coordinator.makeWebView(url: AppConstants.URLs.privacyPolicy) {
                showPrivacyPolicy = false
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showMarketingTemrs) {
            coordinator.makeWebView(url: AppConstants.URLs.marketingTemrs) {
                showMarketingTemrs = false
            }
        }
        .onChange(of: viewModel.isSuccess) { isSuccess in
            if isSuccess {
                coordinator.path.append(LoginDestination.profileSetup)
            }
        }
    }
}



#Preview {
    let mockDIContainer = MockLoginDIContainer()
    let coordinator = LoginCoordinator(loginDIContainer: mockDIContainer)
    return mockDIContainer.makeTermsView(coordinator: coordinator)
}
