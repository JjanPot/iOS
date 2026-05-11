//
//  ProfileEditViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 5/10/26.
//


import SwiftUI
import Combine
final class ProfileEditViewModel: ObservableObject {
    
    @Published var nickname: String = ""
    @Published var nicknameErrorMessage: String? = nil
    @Published var birthDate: Date? = nil
    @Published var imageSource: ProfileImageSource? = nil
    
    
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var isSuccess: Bool = false
    
    private let useCase: ProfileEditUseCaseProtocol
    init(useCase: ProfileEditUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // 유저정보 가져오기
    @MainActor
    func loadUserInfo(){
        isLoading = true
        
        // 로컬 정보 먼저 넣어두고
        if let currentUser = AuthManager.shared.currentUser {
            self.nickname = currentUser.nickname
            self.birthDate = currentUser.birthDate
            self.imageSource = if let url = currentUser.imageUrl {
                .network(url)
            } else { nil }
        }
        
        // 서버에서 가져와서 갈아끼기.
        Task {
            do {
                let entity = try await useCase.getUserInfo()
                self.nickname = entity.nickname
                self.birthDate = entity.birthDate
                self.imageSource = if let url = entity.imageUrl {
                    .network(url)
                } else { nil }
                
            } catch {
                self.nickname = ""
                self.imageSource = nil
                self.birthDate = nil
                
                if let networkError = error as? NetworkError {
                    Logger.error("내 정보가져오기: \(networkError.description)")
                } else {
                    Logger.error("내 정보가져오기: \(error)")
                }
            }
            isLoading = false
        }
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
                let _ = try await useCase.setProfile(nickname: nickname, birthDate: date, image: profileImage)
                isSuccess = true
                ToastManager.shared.show("수정 되었습니다.")
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
