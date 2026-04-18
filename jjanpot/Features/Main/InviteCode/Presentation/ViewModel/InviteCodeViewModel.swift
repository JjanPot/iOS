//
//  InviteCodeViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/27/26.
//

import Foundation
import Combine

final class InviteCodeViewModel: ObservableObject {
    private let useCase: InviteCodePopupUseCaseProtocol
    private let isOnboarding: Bool
    
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var inviteCodeErrorMessage: String? = nil
    @Published var isSuccess = false
    
    init(useCase: InviteCodePopupUseCaseProtocol, isOnboarding: Bool) {
        self.useCase = useCase
        self.isOnboarding = isOnboarding
    }
    
    func checkInviteCode(_ code: String)  {
        isLoading = true
        isSuccess = false
        Task {
            do {
                try await useCase.submitInviteCode(code: code, isOnboarding: isOnboarding)
                isLoading = false
                isSuccess = true
                ToastManager.shared.show("등록되었습니다.")
            } catch {
                if let networkError = error as? NetworkError {
                    ToastManager.shared.show(networkError.description)
                    Logger.error("초대코드 입력 실패 \(networkError.description)")
                } else {
                    Logger.error("초대코드 입력 실패 \(error.localizedDescription)")
                    if let networkError = error as? NetworkError {
                        ToastManager.shared.show(networkError.description)
                        //inviteCodeErrorMessage = networkError.description
                    }
                }
                isLoading = false
            }
        }
    }
}
