//
//  TermsViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


import SwiftUI
import Combine
final class TermsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var isSuccess = false
    
    private let useCase: TermsUseCaseProtocol
    init(useCase: TermsUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func agreeTerms(marketingAgreed: Bool ){
        isLoading = true
        isSuccess = false
        Task {
            do {
                try await useCase.agreeTerms(marketingConsentAgreed: marketingAgreed)
                Logger.success("약관 동의 성공")
                isLoading = false
                isSuccess = true
                
            } catch {
                if let networdError = error as? NetworkError,
                   networdError.description.contains("이미 약관 동의를 완료")
                {
                    Logger.success("약관 동의 성공")
                    isLoading = false
                    isSuccess = true
                    return
                }
                Logger.error("약관 동의 실패 \(error.localizedDescription)")
                toastMessage = "약관 동의 실패"
                isLoading = false
            }
            
        }
    }
}
