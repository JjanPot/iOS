//
//  MyPotViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


import SwiftUI
import Combine
final class MyPotViewModel: ObservableObject {
    
    private let useCase: MyPotUseCaseProtocol
    init(useCase: MyPotUseCaseProtocol) {
        self.useCase = useCase
    }
    @Published var profileViewData: UserProfileViewData?
    @Published var myStatsViewData: MyStatsViewData?
    @Published var isLoading = false
    @Published var toastMessage: String?
    
    
    @MainActor
    func getMyChallengeStats() {
        isLoading = true
        Task {
            do {
                let entity = try await useCase.getMyChallengeStats()
                myStatsViewData = MyStatsViewData(from: entity)
            } catch {
                if let networkError = error as? NetworkError {
                    Logger.error("나의 챌린지 정보 가져오기 실패: \(networkError.description)")
                    toastMessage = networkError.description
                } else {
                    Logger.error("나의 챌린지 정보 가져오기 실패: \(error.localizedDescription)")
                    //toastMessage = error.localizedDescription
                }
            }
            isLoading = false
        }
    }
    
    @MainActor
    func loadUserInfo(){
        isLoading = true
        
        // 로컬 정보 먼저 넣어두고
        if let currentUser = AuthManager.shared.currentUser {
            self.profileViewData = UserProfileViewData(from: currentUser)
        }
        
        // 서버에서 가져와서 갈아끼기.
        Task {
            do {
                let entity = try await useCase.getUserInfo()
                self.profileViewData = UserProfileViewData(from: entity)
            } catch {
                if let networkError = error as? NetworkError {
                    Logger.error("내 정보가져오기: \(networkError.description)")
                } else {
                    Logger.error("내 정보가져오기: \(error)")
                }
            }
            isLoading = false
        }
    }
    
}
