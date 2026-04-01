//
//  ChallengePostViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//


import SwiftUI
import Combine
import UIKit

final class ChallengePostViewModel: ObservableObject {

    private let challengeId: Int
    private let useCase: ChallengePostUseCaseProtocol

    @Published var categoryViewData: [CategorySelectorViewData] = []
    @Published var selectedCategory: CategorySelectorViewData? = nil


    @Published var isSuccess = false
    @Published var isLoading = false
    @Published var toastMessage: String?



    init(challengeId: Int, useCase: ChallengePostUseCaseProtocol) {
        self.challengeId = challengeId
        self.useCase = useCase
    }

    // MARK: input methods
    @MainActor
    func submit(
        expenseType: ChallengePostTab,
        category: CategorySelectorViewData?,
        price: String,
        description: String,
        date: Date,
        selectedImage: Image?
    ){
        // 필수값 체크
        guard let category, price.isNotEmpty else {
            toastMessage = "필수 항목을 입력해주세요"
            return
        }

        isLoading = true

        Task {
            do {
                // Image를 UIImage로 변환
                let uiImage: UIImage? = selectedImage.flatMap { image in
                    let renderer = ImageRenderer(content: image)
                    return renderer.uiImage
                }

                // spendType 결정
                let spendType = expenseType == .expense ? "SPEND" : "NO_SPEND"

                // 가격을 Int로 변환
                let spentAmount: Int? = nil
                if expenseType == .expense {
                    guard let spentAmount = Int(price) else {
                        toastMessage = "올바른 금액을 입력해주세요"
                        isLoading = false
                        return
                    }
                }

                //  생성
                let entity = ChallengePostRequestEntity(
                    challengeId: challengeId,
                    spendType: spendType,
                    categoryId: category.id,
                    spentAmount: spentAmount,
                    memo: description,
                    spentAt: date
                )

                // API 호출
                try await useCase.postChallenge(entity: entity, image: uiImage)

                isLoading = false
                ToastManager.shared.show("인증되었습니다")
                isSuccess = true
                // 화면 닫기는 coordinator에서 처리
            } catch {
                Logger.error("챌린지 인증 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    ToastManager.shared.show(networkError.description)
                } else {
                    toastMessage = "인증에 실패했습니다"
                }
            }
            isLoading = false
        }
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


extension CategorySelectorViewData {
    init(from entity: CategoryEntity) {
        
        let imageName: String
        switch entity.categoryId {
        case 1: imageName = "icon_category_food"
        case 2: imageName = "icon_category_cafe"
        case 3: imageName = "icon_category_car"
        case 4: imageName = "icon_category_fashion"
        case 5: imageName = "icon_category_hobby"
        case 6: imageName = "icon_category_bear"
        case 7: imageName = "icon_category_etc"
        default: imageName = ""
        }
        
        self.id = entity.categoryId
        self.name =  entity.name
        self.icon = imageName
        self.amount = entity.amount
        
    }
}
