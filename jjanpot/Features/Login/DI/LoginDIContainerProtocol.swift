//
//  LoginDIContainerProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation
import SwiftUI

protocol LoginDIContainerProtocol {
    func makeLoginCoordinator() -> LoginCoordinator

    // 로그인 화면
    func makeLoginView(coordinator: LoginCoordinator, onNavigateToMain: @escaping () -> Void) -> LoginView

    // 약관 동의 화면
    func makeTermsView(coordinator: LoginCoordinator) -> TermsView

    // 프로필 설정 화면
    func makeProfileSetupView(coordinator: LoginCoordinator) -> ProfileSetupView
    
    // 초대 코드 화면
    func makeInviteCodeView(coordinator: LoginCoordinator, hasSkip: Bool) -> OnBoardingInviteCodeView

    // 회원가입 완료 화면
    func makeSignUpCompleteView(onNavigateToMain: @escaping () -> Void) -> SignUpCompleteView

    // 웹뷰
    func makeWebView(url: String, onDismiss: @escaping () -> Void) -> AnyView
}

final class LoginDIContainer: LoginDIContainerProtocol {

    private let authApiClient: AuthApiClientProtocol
    private let challengeApiClient: ChallengeApiClientProtocol

    init(authApiClient: AuthApiClientProtocol, challengeApiClient: ChallengeApiClientProtocol) {
        self.authApiClient = authApiClient
        self.challengeApiClient = challengeApiClient
    }

    // MARK: - Coordinator

    func makeLoginCoordinator() -> LoginCoordinator {
        return LoginCoordinator(loginDIContainer: self)
    }

    // MARK: - SocialLogin

    private func makeLoginRepository() -> LoginRepositoryProtocol {
        return LoginRepository(authApiClient: authApiClient)
    }
    private func makeLoginUseCase() -> LoginUseCase {
        return LoginUseCase(repository: makeLoginRepository())
    }
    private func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(useCase: makeLoginUseCase())
    }

    func makeLoginView(coordinator: LoginCoordinator, onNavigateToMain: @escaping () -> Void) -> LoginView {
        let viewModel = makeLoginViewModel()
        return LoginView(viewModel: viewModel, coordinator: coordinator, onNavigateToMain: onNavigateToMain)
    }

    // MARK: - Terms
    private func makeTermsRepository() -> TermsRepositoryProtocol {
        return TermsRepository(authApiClient: authApiClient)
    }
    private func makeTermsUseCase() -> TermsUseCaseProtocol {
        let repo = makeTermsRepository()
        return TermsUseCase(repository: repo)
    }
    private func makeTermsViewModel() -> TermsViewModel {
        let usecase = makeTermsUseCase()
        return TermsViewModel(useCase: usecase)
    }

    func makeTermsView(coordinator: LoginCoordinator) -> TermsView {
        let vm = makeTermsViewModel()
        return TermsView(viewModel: vm, coordinator: coordinator)
    }

    // MARK: - ProfileSetup


    private func makeProfileSetupRepository() -> ProfileSetupRepositoryProtocol {
            return ProfileSetupRepository(authApiClient: authApiClient)
        }
        private func makeProfileSetupUseCase() -> ProfileSetupUseCaseProtocol {
            let repo = makeProfileSetupRepository()
            return ProfileSetupUseCase(repository: repo)
        }
        private func makeProfileSetupViewModel() -> ProfileSetupViewModel {
            let usecase = makeProfileSetupUseCase()
            return ProfileSetupViewModel(useCase: usecase)
        }

        func makeProfileSetupView(coordinator: LoginCoordinator) -> ProfileSetupView {
            let vm = makeProfileSetupViewModel()
            return ProfileSetupView(viewModel: vm, coordinator: coordinator)
        }

    // MARK: - SignUpComplete

    func makeSignUpCompleteView(onNavigateToMain: @escaping () -> Void) -> SignUpCompleteView {
        return SignUpCompleteView(onNavigateToMain: onNavigateToMain)
    }
    
    // MARK: - InviteCode

    private func makeInviteCodePopupRepository() -> InviteCodePopupRepositoryProtocol {
        return InviteCodePopupRepository(challengeApiClient: challengeApiClient)
    }
    
    private func makeInviteCodePopupUseCase() -> InviteCodePopupUseCaseProtocol {
        let repo = makeInviteCodePopupRepository()
        return InviteCodePopupUseCase(repository: repo)
    }
    private func makeInviteCodeViewModel() -> InviteCodeViewModel {
        let usecase = makeInviteCodePopupUseCase()
        return InviteCodeViewModel(useCase: usecase)
    }
    
    func makeInviteCodeView(coordinator: LoginCoordinator, hasSkip: Bool = true) -> OnBoardingInviteCodeView {
        let vm = makeInviteCodeViewModel()
        return OnBoardingInviteCodeView(viewModel: vm, coordinator: coordinator, hasSkip: hasSkip)
    }

    // MARK: - Web view
    
    func makeWebView(url: String, onDismiss: @escaping () -> Void) -> AnyView {
        return AnyView(
            NavigationStack {
                AdvancedWebView(
                    url: URL(string: url)!,
                    isLoading: .constant(false)
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            onDismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        )
    }
}

// MARK: - Mock


final class MockLoginDIContainer: LoginDIContainerProtocol {

    func makeLoginCoordinator() -> LoginCoordinator {
        return LoginCoordinator(loginDIContainer: self)
    }

    // MARK: Login
    private func makeLoginUseCase() -> LoginUseCaseProtocol {
        return MockLoginUseCase()
    }
    private func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(useCase: makeLoginUseCase())
    }
    func makeLoginView(coordinator: LoginCoordinator, onNavigateToMain: @escaping () -> Void) -> LoginView {
        let viewModel = makeLoginViewModel()
        return LoginView(viewModel: viewModel, coordinator: coordinator, onNavigateToMain: onNavigateToMain)
    }

    func makeTermsView(coordinator: LoginCoordinator) -> TermsView {
        let usecase = MockTermsUseCase()
        let vm = TermsViewModel(useCase: usecase)
        return TermsView(viewModel: vm, coordinator: coordinator)
    }

    func makeProfileSetupView(coordinator: LoginCoordinator) -> ProfileSetupView {
        let usecase = MockProfileSetupUseCase()
        let vm = ProfileSetupViewModel(useCase: usecase )
        return ProfileSetupView(viewModel: vm, coordinator: coordinator)
    }

    func makeSignUpCompleteView(onNavigateToMain: @escaping () -> Void) -> SignUpCompleteView {
        return SignUpCompleteView(onNavigateToMain: onNavigateToMain)
    }

    func makeWebView(url: String, onDismiss: @escaping () -> Void) -> AnyView {
        return AnyView(EmptyView())
    }
    
    func makeInviteCodeView(coordinator: LoginCoordinator, hasSkip: Bool) -> OnBoardingInviteCodeView {
        let vm = InviteCodeViewModel(useCase: MockInviteCodePopupUseCase())
        return OnBoardingInviteCodeView(viewModel: vm, coordinator: coordinator, hasSkip: hasSkip)
    }
    
}

// -------- Mock struct ------ //

struct MockLoginUseCase: LoginUseCaseProtocol {
    func cancelLogin(entity: LoginEntity) async throws {}
    func login(entity: LoginEntity) {}
    func loginWithApple() async throws -> LoginEntity {
        throw NetworkError.dataNil
    }
    func loginWithKakao() async throws -> LoginEntity {
        throw NetworkError.dataNil
    }
    func loginWithGoogle() async throws -> LoginEntity {
        throw NetworkError.dataNil
    }
}
struct MockTermsUseCase: TermsUseCaseProtocol {
    func agreeTerms(marketingConsentAgreed: Bool) async throws {
        throw NetworkError.dataNil
    }
}
struct MockProfileSetupUseCase: ProfileSetupUseCaseProtocol {
    func setProfile(nickname: String, birthDate: String?, imageUrl: String?) async throws {
        throw NetworkError.dataNil
    }
}
