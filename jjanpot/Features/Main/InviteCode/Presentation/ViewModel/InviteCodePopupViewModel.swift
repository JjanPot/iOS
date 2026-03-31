//
//  InviteCodePopupViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/27/26.
//

import Foundation
import Combine

final class InviteCodePopupViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var isSuccess = false
    
    private let useCase: InviteCodePopupUseCaseProtocol
    init(useCase: InviteCodePopupUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func checkInviteCode(_ code: String)  {
        isLoading = true
        isSuccess = false
        Task {
            do {
                try await useCase.submitInviteCode(code: code)
                isLoading = false
                isSuccess = true
                ToastManager.shared.show("등록되었습니다.")
            } catch {
                if let networkError = error as? NetworkError {
                    ToastManager.shared.show(networkError.description)
                    Logger.error("초대코드 입력 실패 \(networkError.description)")
                } else {
                    Logger.error("초대코드 입력 실패 \(error.localizedDescription)")
                }
                isLoading = false
            }
        }
    }
}
