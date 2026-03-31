//
//  CreateChallengeView.swift
//  jjanpot
//
//  Created by 임주희 on 3/28/26.
//

import SwiftUI

enum FocusedField {
    case challengeName
    case challengeDescription
    case memberCount
    case teamPrice
    case personalPrice
}

// 챌린지 만들기
struct CreateChallengeView: View {
    @StateObject var viewModel: CreateChallengeViewModel
    @ObservedObject var coordinator: MainCoordinator

    @State var challengeName: String = ""
    @State var description: String = ""
    @State var selectedRelationshipType: RelationshipType? = nil

    // 멤버 유형, 인원
    @State var memberCount: Double = 0.0

    // 챌린지 기간
    @State var startDate: Date?
    @State var endDate: Date?

    // 절약항목
    @State var selectedCategories: [SavingCategoryViewData] = []
    @State var categoryAmounts: [SavingCategoryViewData: Int] = [:]

    // 목표 금액(팀)
    @State var teamTargetPrice: Double = 0
    // 목표 금액 (개인)
    @State var personalTargetPrice: Double = 0

    // 포커스 상태 관리
    @FocusState private var focusedField: FocusedField?

    init(viewModel: CreateChallengeViewModel, coordinator: MainCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }

   
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                messageBox
                    .padding(.top, 20)
                
                // 챌린지 이름
                challengeNameTextField
                
                // 챌린지 설명
                challengeDescription
                
                // 모집 인원, 유형
                memberType
                MemberSliderView(
                    memberCount: $memberCount,
                    focusedField: $focusedField,
                    fieldIdentifier: .memberCount
                )

                // 챌린지 기간
                challengeDurationView

                // 절약항목
                savingCategory
                
                // 목표 금액(팀)
                teamTargetPriceView
                
                // 목표 금액 (개인)
                personalTargetPriceView
                
                
                MainButton(title: "챌린지 만들기") {
                    handleCreateChallenge()
                }
                .padding(.vertical, 100)
                
            }
            .padding(.horizontal, 20)
            
        }
        .task {
            viewModel.loadCategories()
        }
        .navigationTitle("챌린지 만들기")
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .onChange(of: viewModel.isSuccess) { isSuccess in
            if isSuccess {
                coordinator.popToRoot()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") {
                    // 모든 포커스 해제
                    focusedField = nil
                }
                .foregroundStyle(.orange500)
            }
        }
    }
    
    private var messageBox: some View {
        VStack (alignment: .leading, spacing: 6) {
            Text("새로운 절약 챌린지를 만들어 보세요.")
                .font(.pretendard(.medium, size: 14))
            Text("팀원들과 함께 목표를 정하고 절약을 시작해 보세요.")
                .font(.pretendard(.regular, size: 12))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 17)
        .background(Color.orange100)
        .rounded(radius: 12)
    }
    
    // 챌린지 이름
    private var challengeNameTextField: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView(title: "챌린지 이름",
                      description: "우리 챌린지의 이름을 입력해 주세요",
                      isNeccessary: true
            )
            
            TextField("", text: $challengeName, prompt:
                        Text("최대 14글자까지 입력해 주세요")
                .font(.pretendard(.regular, size: 14))
                .foregroundColor(Color.black200)
            )
            .font(.pretendard(.regular, size: 14))
            .foregroundColor(Color.black900)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .roundedBorder(color: .black100, radius: 12)
            .focused($focusedField, equals: .challengeName)
            .onChange(of: challengeName) { newValue in
                if newValue.count > 14 {
                    challengeName = String(newValue.prefix(14))
                }
            }
            
        }
    }
    
    // 챌린지 설명
    private var challengeDescription: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView(title: "챌린지 설명",
                      description: "팀원들과 공유할 메모를 남겨보세요.",
                      isNeccessary: false
            )
            
            ZStack(alignment: .topLeading) {
                // 1. 실제 입력창
                TextEditor(text: $description)
//                    .scrollContentBackground(.hidden)
//                    .background(Color.red)
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black900)
                    .focused($focusedField, equals: .challengeDescription)
                    .onChange(of: description) { newValue in
                        if newValue.count > 80 {
                            challengeName = String(newValue.prefix(80))
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    
                
                // 2. 글자가 비어있을 때만 보여주는 Placeholder
                if description.isEmpty {
                    Text("최대 14글자까지 입력해 주세요")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color.black200)
                        .allowsHitTesting(false) // 중요: 터치 이벤트가 뒤의 TextEditor로 전달되게 함
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                }
            }
            .frame(height: 104)
            .roundedBorder(color: .black100, radius: 12)
        }
    }
    
    private var memberType: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView(title: "모집 인원, 유형",
                      description: "누구와 함께, 몇 명이 챌린지에 참여하나요?",
                      isNeccessary: true
            )
            GridSingleSelector(selectedItem: $selectedRelationshipType, columns: 3)
        }
    }
    
    
    // 챌린지 기간
    private var challengeDurationView: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView(title: "챌린지 기간",
                      description: "언제부터 챌린지를 시작할까요?(일주일동안 진행돼요.)",
                      isNeccessary: true
            )
            
            RangeCalendarView(
                startDate: $startDate,
                endDate: $endDate,
                rangeDays: 7
            )
        }
    }
    
    // 절약 항목
    private var savingCategory: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView(title: "절약 항목",
                      description: "무엇을 절약할 건가요? (3개까지 선택 가능해요.)",
                      isNeccessary: true
            )

            if viewModel.categories.isEmpty {
                Text("카테고리 로딩 중...")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundStyle(Color.black500)
            } else {
                DynamicGridMultipleSelector(
                    selectedItems: $selectedCategories,
                    items: viewModel.categories,
                    maxSelection: 3
                )

                // 카테고리 별 기준 금액 선택 (선택 순서대로 표시)
                ForEach(selectedCategories) { category in
                    CategoryAmountSelector(
                        category: category,
                        selectedAmount: Binding(
                            get: { categoryAmounts[category] },
                            set: { categoryAmounts[category] = $0 }
                        )
                    )
                }
            }
        }
    }
    
    
    // 팀 목표금액의 최소금액
    var teamTargetMinPrice: Double {
        let price = memberCount * 5000
        return price < 10000 ? 10000 : price
    }
    
    // 목표 금액(팀)
    private var teamTargetPriceView: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView(title: "목표 금액(팀)",
                      description: "우리 팀의 절약 목표 금액은 얼마인가요?",
                      isNeccessary: true
            )
            
            PriceSliderView(
                price: $teamTargetPrice,
                focusedField: $focusedField,
                fieldIdentifier: .teamPrice,
                minPrice: teamTargetMinPrice,
                maxPrice: 3000000,
                step: 5000,
                placeholder: "최대 300만"
            )
        }
    }
    
    
    // 목표 금액 (개인)
    private var personalTargetPriceView: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView(title: "목표 금액(개인)",
                      description: "각자 최소 얼마씩 절약해야 하나요?",
                      isNeccessary: true
            )
            
            PriceSliderView(
                price: $personalTargetPrice,
                focusedField: $focusedField,
                fieldIdentifier: .personalPrice,
                minPrice: 5000,
                maxPrice: 300000,
                step: 5000,
                placeholder: "최대 30만"
            )
        }
    }

    // MARK: - Actions
    
    // 입력값 검증
    private func isValidForm() -> Bool {
        // 챌린지 이름
        guard challengeName.isNotEmpty else {
            viewModel.toastMessage = "챌린지 이름을 입력해주세요"
            return false
        }
        
        //모집 유형
        guard selectedRelationshipType != nil else {
            viewModel.toastMessage = "모집 유형을 선택해주세요"
            return false
        }
        
        // 모집 인원
        guard memberCount >= 2 && memberCount <= 8 else {
            viewModel.toastMessage = "모집 인원을 확인해주세요"
            return false
        }
        
        // 챌린지 기간 (시작일)
        guard startDate != nil else {
            viewModel.toastMessage = "챌린지 시작일을 선택해주세요"
            return false
        }
        
        // 절약 항목
        guard selectedCategories.isNotEmpty else {
            viewModel.toastMessage = "절약 항목을 선택해주세요"
            return false
        }
        
        // 선택한 절약항목의, 기준 금액 선택 여부
        guard selectedCategories.count == categoryAmounts.keys.count else {
            viewModel.toastMessage = "절약 항목의 기준 금액을 선택해주세요."
            return false
        }

        // 목표금액 (팀)
        guard teamTargetPrice >= teamTargetMinPrice && teamTargetPrice <= 3000000 else {
            viewModel.toastMessage = "팀 목표 금액을 확인해주세요"
            return false
        }

        // 목표금액 (개인)
        guard personalTargetPrice >= 5000 && personalTargetPrice <= 300000 else {
            viewModel.toastMessage = "개인 목표 금액을 확인해주세요"
            return false
        }
        return true
    }

    private func handleCreateChallenge() {
        // 필수값 검증
        guard isValidForm() else { return }
        
        guard let relationshipType = selectedRelationshipType else {
            viewModel.toastMessage = "모집 유형을 선택해주세요"
            return
        }
        
        guard let startDate = startDate else {
            viewModel.toastMessage = "챌린지 시작일을 선택해주세요"
            return
        }
        
        viewModel.createChallenge(
            title: challengeName,
            description: description,
            relationshipType: relationshipType,
            memberCount: Int(memberCount),
            startDate: startDate,
            selectedCategories: selectedCategories,
            categoryAmounts: categoryAmounts,
            teamTargetPrice: Int(teamTargetPrice),
            personalTargetPrice: Int(personalTargetPrice)
        )
    }
}


#Preview {
    let container = MockMainDIContainer()
    let coordinator = container.makeMainCoordinator()
    return container.makeCreateChallengeView(coordinator: coordinator)
}
