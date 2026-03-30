//
//  CreateChallengeViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation
import Combine


final class CreateChallengeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var isSuccess = false
    @Published var categories: [SavingCategoryViewData] = []

    private let useCase: CreateChallengeUseCaseProtocol

    init(useCase: CreateChallengeUseCaseProtocol) {
        self.useCase = useCase
    }

    
    // 카테고리 목록 가져오기
    @MainActor
    func loadCategories() {
        isLoading = true
        Task {
            do {
                let entities = try await useCase.getCategories()
                // Entity → ViewData 변환
                categories = entities.map { SavingCategoryViewData(from: $0) }
            } catch {
                Logger.error("카테고리 로딩에 실패했습니다: \(error.localizedDescription)")
                toastMessage = "카테고리 로딩에 실패했습니다"
            }
            isLoading = false
        }
    }

    // 챌린지 생성
    @MainActor
    func createChallenge(
        title: String,
        description: String,
        relationshipType: RelationshipType,
        memberCount: Int,
        startDate: Date,
        selectedCategories: [SavingCategoryViewData],
        categoryAmounts: [SavingCategoryViewData: Int],
        teamTargetPrice: Int,
        personalTargetPrice: Int
    ){
        // 카테고리별 금액 매핑 (Entity 생성)
        let categories = selectedCategories.compactMap { category -> CreateChallengeRequestEntity.CategoryWithAmount? in
            guard let amount = categoryAmounts[category] else { return nil }
            return CreateChallengeRequestEntity.CategoryWithAmount(categoryId: category.id, amount: amount)
        }

        isLoading = true
        
        Task {
            do {
                _ = try await useCase.createChallenge(
                    title: title,
                    description: description,
                    teamType: relationshipType.apiValue,
                    maxMemberCount: memberCount,
                    startDate: startDate,
                    categories: categories,
                    goalAmount: teamTargetPrice,
                    minPersonalGoalAmount: personalTargetPrice
                )
                Logger.success("챌린지가 생성되었습니다")
                ToastManager.shared.show("챌린지가 생성되었습니다")
                isSuccess = true
            } catch {
                Logger.error("챌린지 생성에 실패했습니다: \(error.localizedDescription)")
                toastMessage = "챌린지 생성에 실패했습니다: \(error.localizedDescription)"
            }
        }
        isLoading = false
    }
}
