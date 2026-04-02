//
//  ProfileSetupViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//


import SwiftUI
import Combine

final class ProfileSetupViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var nicknameErrorMessage: String? = nil
    @Published var birthDate: Date? = nil
    @Published var profileImage: Image? = nil
    
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var isSuccess: Bool = false
    
    
    private let useCase: ProfileSetupUseCaseProtocol
   init(useCase: ProfileSetupUseCaseProtocol) {
       self.useCase = useCase
   }
    
    @MainActor
    func setProfile(){
        guard nickname.isNotEmpty else { return }
        isLoading = true
        isSuccess = false
        
        let date = birthDate?.toString(.dateOnly)
        
        Task {
            do {
                // TODO: 이미지 업로드 구현하기
                try await useCase.setProfile(nickname: nickname, birthDate: date, imageUrl: nil)
                isSuccess = true
                ToastManager.shared.show("등록되었습니다.")
            } catch {
                Logger.error("프로필 설정 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    toastMessage = networkError.description
                } else {
                    toastMessage = "프로필 설정 실패"
                }
            }
        }
        
    }
}
