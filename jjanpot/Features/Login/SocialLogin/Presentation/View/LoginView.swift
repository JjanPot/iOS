//
//  LoginView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

struct LoginView: View {

    @StateObject var viewModel: LoginViewModel
    @ObservedObject var coordinator: LoginCoordinator
    let onNavigateToMain: () -> Void

    init(viewModel: LoginViewModel, coordinator: LoginCoordinator, onNavigateToMain: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
        self.onNavigateToMain = onNavigateToMain
    }

    var body: some View {
        VStack(spacing: 71) {

            Spacer()

            VStack(spacing: .zero) {
                Image("TextLogo")
                    .resizable()
                    .frame(width: 200, height: 30)

                Spacer()
                    .frame(height: 23.8)

                Text("함께하는 절약에 도전하세요")
                    .font(.pretendard(.semiBold), size: 20)
                    .foregroundStyle(Color(hex: "6e6e6e"))

                Spacer()
                    .frame(height: 49)

                Image("charater")
                    .resizable()
                    .frame(width: 173, height: 162)
            }

            VStack(spacing: 16) {
                Button {
                    viewModel.clickKakaoLoginButton()
                } label: {
                    HStack {

                        Spacer()

                        Text("카카오로 로그인")
                            .font(.pretendard(.semiBold), size: 16)
                            .foregroundStyle(.black)

                        Spacer()
                    }
                    .overlay(alignment: .leading, content: {
                        Image("kakaoLogo")
                            .resizable()
                            .frame(width: 24, height: 22.54)
                    })
                    .frame(height: 48)
                    .padding(.horizontal, 16)
                    .background(Color(hex: "FEE500"))
                    .cornerRadius(8)
                }

                Button {
                    viewModel.clickAppleLoginButton()
                } label: {
                    HStack {
                        Spacer()

                        Text("애플로 로그인")
                            .font(.pretendard(.semiBold), size: 16)
                            .foregroundStyle(.white)

                        Spacer()
                    }
                    .overlay(alignment: .leading, content: {
                        Image("appleLogo")
                            .resizable()
                            .frame(width: 24, height: 24)
                    })
                    .frame(height: 48)
                    .padding(.horizontal, 16)
                    .background(Color.black)
                    .cornerRadius(8)
                }

                Button {
                    viewModel.clickGoogleLoginButton()
                } label: {
                    HStack {
                        Spacer()
                        Text("구글로 로그인")
                            .font(.pretendard(.semiBold), size: 16)
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    .overlay(alignment: .leading, content: {
                        Image("googleLogo")
                            .resizable()
                            .frame(width: 24, height: 24.49)
                    })
                    .frame(height: 48)
                    .padding(.horizontal, 16)
                }
                .roundedBorder(color: .black300, radius: 8)

            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)

            Spacer()


        }
        .padding(.top, 20)
        .onChange(of: viewModel.shouldNavigateToSignup) { shouldNavigate in
            if shouldNavigate {
                coordinator.navigateToTerms()
            }
        }
        .onChange(of: viewModel.shouldNavigateToMain) { shouldNavigate in
            if shouldNavigate {
                onNavigateToMain()
            }
        }
    }
}

#Preview {
    let container = AppDIContainer.shared
    let coordinator = container.loginDIContainer.makeLoginCoordinator()
    return container.loginDIContainer.makeLoginView(coordinator: coordinator, onNavigateToMain: {
        print("Navigate to main")
    })
}
