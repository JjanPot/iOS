//
//  CreateChallengeViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation
import Combine

@MainActor
final class CreateChallengeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var isSuccess = false
    @Published var categories: [CategoryViewData] = []

    private let useCase: CreateChallengeUseCaseProtocol

    init(useCase: CreateChallengeUseCaseProtocol) {
        self.useCase = useCase
    }

    // 카테고리 목록 가져오기
    func loadCategories() {
        isLoading = true
        Task {
            do {
                let entities = try await useCase.fetchCategories()
                // Entity → ViewData 변환
                categories = entities.map { CategoryViewData(from: $0) }
            } catch {
                Logger.error("카테고리 로딩에 실패했습니다: \(error.localizedDescription)")
                toastMessage = "카테고리 로딩에 실패했습니다"
            }
            isLoading = false
        }
    }

    // 챌린지 생성
    func createChallenge(
        title: String,
        description: String,
        relationshipType: RelationshipType,
        memberCount: Int,
        startDate: Date,
        selectedCategories: [CategoryViewData],
        categoryAmounts: [CategoryViewData: Int],
        teamTargetPrice: Int,
        personalTargetPrice: Int
    ) async {
        // 입력값 검증
        guard !title.isEmpty else {
            toastMessage = "챌린지 이름을 입력해주세요"
            return
        }

        guard !selectedCategories.isEmpty else {
            toastMessage = "절약 항목을 선택해주세요"
            return
        }

        guard teamTargetPrice > 0 else {
            toastMessage = "팀 목표 금액을 입력해주세요"
            return
        }

        guard personalTargetPrice > 0 else {
            toastMessage = "개인 목표 금액을 입력해주세요"
            return
        }

        // 카테고리별 금액 매핑 (Entity 생성)
        let categories = selectedCategories.compactMap { category -> CreateChallengeRequestEntity.CategoryWithAmount? in
            guard let amount = categoryAmounts[category] else { return nil }
            return CreateChallengeRequestEntity.CategoryWithAmount(categoryId: category.id, amount: amount)
        }

        // 날짜 포맷
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = dateFormatter.string(from: startDate)

        // API 호출
        isLoading = true
        do {
            _ = try await useCase.createChallenge(
                title: title,
                description: description,
                teamType: relationshipType.apiValue,
                maxMemberCount: memberCount,
                startDate: startDateString,
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
        isLoading = false
    }
}
