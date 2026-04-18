//
//  FeedEditViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/16/26.
//

import Foundation
import SwiftUI
import Combine


final class FeedEditViewModel: ObservableObject {
    
    private let challengeId: Int
    private let originFeedEntity: FeedEntity
    private let useCase: FeedEditUseCaseProtocol
    
    @Published var selectedTab: ChallengePostTab
    @Published var selectedCategory: CategorySelectorViewData? = nil
    @Published var categoryViewData: [CategorySelectorViewData] = []
    
    //
    
    @Published var price: String = ""
    
    @Published var description: String = ""
    
    @Published var isShowingPicker = false
    @Published var selectedDate: Date
    
    // 업로드된 이미지
    @Published var uploadedImageUrl: String?
    
    @Published var isSuccess = false
    @Published var isLoading = false
    @Published var toastMessage: String?
    
    
    init(challengeId:Int, feedEntity: FeedEntity, useCase: FeedEditUseCaseProtocol){
        self.useCase = useCase
        self.challengeId = challengeId
        self.originFeedEntity = feedEntity
        self.selectedTab = feedEntity.spendType == .expense ? .expense : .noExpense
        self.description = feedEntity.memo ?? ""
        self.uploadedImageUrl = feedEntity.imageURL
        self.selectedDate = feedEntity.createdAt

    }
    
    
    // 상세정보 가져오기
    // -> 선택된 카테고리 정보 가져오기
    @MainActor
    func getDetail(){
        isLoading = true
        Task {
            do {
                let entity: ChallengeDetailEntity = try await useCase.getDetail(challengeId: challengeId)
                // Entity → ViewData 변환
                
                let category = entity.categories.map {CategorySelectorViewData(from: $0)}
                
                categoryViewData = category.filter({
                    $0.name == originFeedEntity.categoryName
                })
                selectedCategory = categoryViewData.first {
                    $0.name == originFeedEntity.categoryName
                }
                
                if let amount = selectedCategory?.amount {
                    let priceValue = amount - originFeedEntity.savedAmount
                    self.price = "\(priceValue)"
                }
                
                
            } catch {
                Logger.error("상세정보 불러오기 실패: \(error.localizedDescription)")
                toastMessage = "상세정보 불러오기 실패"
            }
            isLoading = false
        }
    }
    
    
    func isSubmitButtonDisabled() -> Bool {
        return (selectedTab == .expense) ? ((Int(price) ?? 0 <= 0) || selectedCategory == nil) : (selectedCategory == nil)
    }
    
    
    // 수정하기
    func submit(selectedImageData: Data?){
        isLoading = true
        Task {
            do {
                //  request entity 생성
                guard let entity = requestEntity() else { return }
                try await useCase.updateFeed(feedId: originFeedEntity.id, entity: entity, imageData: selectedImageData)
                
                isLoading = false
                ToastManager.shared.show("수정 되었습니다")
                isSuccess = true
                
            } catch {
                Logger.error("챌린지 인증 수정 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    toastMessage = networkError.description
                } else {
                    toastMessage = "수정에 실패했습니다"
                }
            }
            isLoading = false
        }
    }
    
     
    private func requestEntity() -> ChallengePostRequestEntity? {
        
        // spendType 결정
        let spendType = selectedTab.rawValue
        
        // 지출 탭일 때만, 가격을 Int로 변환
        var spentAmount: Int? = nil
        if selectedTab == .expense {
            guard let priceInt = Int(price) else {
                toastMessage = "올바른 금액을 입력해주세요"
                isLoading = false
                return nil
            }
            spentAmount = priceInt
        }
        
        guard let category = selectedCategory else { return nil }
        
        return ChallengePostRequestEntity(
            challengeId: challengeId,
            spendType: spendType,
            categoryId: category.id,
            spentAmount: spentAmount,
            memo: description,
            spentAt: selectedDate
        )
    }
}
