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
    
    func makeLoginView(coordinator: LoginCoordinator, onNavigateToMain: @escaping () -> Void) -> LoginView
    func makeWebView(url: String, onDismiss: @escaping () -> Void) -> AnyView
}

final class LoginDIContainer: LoginDIContainerProtocol {

    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
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

    func makeWebView(url: String, onDismiss: @escaping () -> Void) -> AnyView {
        return AnyView(EmptyView())
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
