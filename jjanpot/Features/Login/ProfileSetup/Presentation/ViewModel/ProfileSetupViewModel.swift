//
//  ProfileSetupViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//


import SwiftUI
import Combine
import UIKit

final class ProfileSetupViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var nicknameErrorMessage: String? = nil
    @Published var birthDate: Date? = nil
    
    // 여기서는 .local만 쓰임
    @Published var imageSource: ProfileImageSource?
    
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
        
        var profileImage: UIImage?
        if case let .local(uiImage) = imageSource {
            profileImage = uiImage
        }
        
        Task {
            do {
                try await useCase.setProfile(nickname: nickname, birthDate: date, image: profileImage)
                isSuccess = true
                ToastManager.shared.show("등록되었습니다.")
            } catch {
                Logger.error("프로필 설정 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    if networkError.isUserFacing {
                        toastMessage = networkError.description
                    }
                } else {
                    toastMessage = "프로필 설정 실패"
                }
            }
            isLoading = false
        }
    }
    
    func updateLocalImage(_ uiImage:  UIImage){
        imageSource = .local(uiImage)
    }
}
