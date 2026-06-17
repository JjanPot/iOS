//
//  FeedPostViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//


import SwiftUI
import Combine
import UIKit

final class FeedPostViewModel: ObservableObject {

    private let challengeId: Int
    private let useCase: FeedPostUseCaseProtocol

    @Published var categoryViewData: [CategorySelectorViewData] = []
    @Published var selectedCategory: CategorySelectorViewData? = nil

    @Published var isSuccess = false
    @Published var isLoading = false
    @Published var toastMessage: String?



    init(challengeId: Int, useCase: FeedPostUseCaseProtocol) {
        self.challengeId = challengeId
        self.useCase = useCase
    }

    // MARK: input methods
    @MainActor
    func submit(
        expenseType: FeedPostTab,
        category: CategorySelectorViewData?,
        price: String,
        description: String,
        date: Date,
        selectedImageData: Data?
    ){
        // 필수값 체크
        guard let category else {
            toastMessage = "필수 항목을 입력해주세요"
            return
        }

        isLoading = true

        Task {
            do {
                
                //  request entity 생성
                guard let entity = requestEntity(
                    expenseType: expenseType,
                    category: category,
                    price: price,
                    description: description,
                    date: date,
                    selectedImageData: selectedImageData
                    )
                else { return }

                // API 호출
                try await useCase.postChallenge(entity: entity, imageData: selectedImageData)

                isLoading = false
                ToastManager.shared.show("인증되었습니다")
                isSuccess = true
                // 화면 닫기는 coordinator에서 처리
            } catch {
                Logger.error("챌린지 인증 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    if networkError.isUserFacing {
                        toastMessage = networkError.description
                    }
                } else {
                    toastMessage = "인증에 실패했습니다"
                }
            }
            isLoading = false
        }
    }
    
    private func requestEntity(
        expenseType: FeedPostTab,
        category: CategorySelectorViewData,
        price: String,
        description: String,
        date: Date,
        selectedImageData: Data?
    ) -> FeedPostRequestEntity? {
        
        // spendType 결정
        let spendType = expenseType.rawValue

        // 지출 탭일 때만, 가격을 Int로 변환
        var spentAmount: Int? = nil
        if expenseType == .expense {
            guard let priceInt = Int(price) else {
                toastMessage = "올바른 금액을 입력해주세요"
                isLoading = false
                return nil
            }
            spentAmount = priceInt
        }

        
        return FeedPostRequestEntity(
            challengeId: challengeId,
            spendType: spendType,
            categoryId: category.id,
            spentAmount: spentAmount,
            memo: description,
            spentAt: date
        )
    }
    
    // 상세정보 가져오기
    @MainActor
    func getDetail(){
        isLoading = true
        Task {
            do {
                let entity = try await useCase.getDetail(challengeId: challengeId)
                // Entity → ViewData 변환
                categoryViewData = entity.categories.map {CategorySelectorViewData(from: $0)}
                selectedCategory = categoryViewData.first
                
            } catch {
                Logger.error("상세정보 불러오기 실패: \(error.localizedDescription)")
                toastMessage = "상세정보 불러오기 실패"
            }
            isLoading = false
        }
    }
}


