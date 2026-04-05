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
                
                
                #if DEBUG

                Button("로그 공유 (\(Logger.getLogCount())개)"){
                    shareLog()
                }

                #endif


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
    
    private func shareLog() {
        print(">>> shareLog 호출됨")
        print(">>> 현재 로그 개수: \(Logger.getLogCount())")

        // 로그 파일 생성
        guard let fileURL = Logger.exportLogsToFile() else {
            print(">>> 로그 파일 생성 실패")
            ToastManager.shared.show("공유할 로그가 없습니다")
            return
        }

        print(">>> 로그 파일 생성 성공: \(fileURL.path)")

        // UIKit 방식으로 직접 공유 시트 띄우기
        let activityVC = UIActivityViewController(
            activityItems: [fileURL],
            applicationActivities: nil
        )

        // iPad 지원
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {

            // 현재 presented 된 VC 찾기
            var topVC = rootVC
            while let presentedVC = topVC.presentedViewController {
                topVC = presentedVC
            }

            // iPad에서 popover 설정
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = topVC.view
                popover.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }

            topVC.present(activityVC, animated: true)
            print(">>> 공유 시트 표시 완료")
        }

        //Logger.info("로그 파일 공유 준비 완료: \(fileURL.lastPathComponent)")
    }
    
}

#Preview {
    let container = AppDIContainer.shared
    let coordinator = container.loginDIContainer.makeLoginCoordinator()
    return container.loginDIContainer.makeLoginView(coordinator: coordinator, onNavigateToMain: {
        print("Navigate to main")
    })
}
