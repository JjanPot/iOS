//
//  LoginDIContainerProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation
import SwiftUI

protocol LoginDIContainerProtocol {
    func makeLoginView(onDismiss: @escaping () -> Void, appContainer: AppDIContainer) -> LoginView
}

final class LoginDIContainer: LoginDIContainerProtocol {

    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
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

    func makeLoginView(onDismiss: @escaping () -> Void, appContainer: AppDIContainer) -> LoginView {
        let viewModel = makeLoginViewModel()
        return LoginView(viewModel: viewModel, container: appContainer, onDismiss: onDismiss)
    }
}

// MARK: - Mock


final class MockLoginDIContainer: LoginDIContainerProtocol {
   
    // MARK: Login
    private func makeLoginUseCase() -> LoginUseCaseProtocol {
        return MockLoginUseCase()
    }
    private func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(useCase: makeLoginUseCase())
    }
    func makeLoginView(onDismiss: @escaping () -> Void, appContainer: AppDIContainer) -> LoginView {
        let viewModel = makeLoginViewModel()
        return LoginView(viewModel: viewModel, container: appContainer, onDismiss: onDismiss)
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
