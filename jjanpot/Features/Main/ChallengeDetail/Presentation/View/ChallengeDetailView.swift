//
//  ChallengeDetailView.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//

import SwiftUI

// 챌린지 상세 정보
struct ChallengeDetailView: View {
    @StateObject var viewModel: ChallengeDetailViewModel
    private let coordinator: MainCoordinator
    
    init(viewModel: ChallengeDetailViewModel, coordinator: MainCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                // 챌린지 기본 정보
                basicInfoView
                
                // 챌린지 설명
                description
                
                // 챌린지 가이드 라인
                ChallengeGuideLine()
                
                if viewModel.viewData?.hasCancelButton ?? false {
                    Button {
                        viewModel.isShowCancelAlert = true
                    } label: {
                        Text("취소하기")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(Color.orange500)
                    }
                }

            }
            .padding(.horizontal, 20)
        }
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .task {
            viewModel.getDetail()
        }
        .background(Color.orange50)
        .navigationTitle("상세 정보")
        .popup(isPresented: $viewModel.isShowCancelAlert) {
            Modal(title: "챌린지 취소하기", content: "시작전에만 취소가 가능합니다.")
                .buttons {
                    ModalButton(title: "유지하기", size: .middle, colorType: .secondary) {
                        viewModel.isShowCancelAlert = false
                    }
                    ModalButton(title: "취소하기", size: .middle) {
                        viewModel.cancel()
                    }
                }
        }
        .onChange(of: viewModel.isCancelled) { isCancelled in
            if isCancelled {
                coordinator.pop()
            }
        }
    }
    
    
    // 챌린지 기본정보 뷰
    var basicInfoView: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.viewData?.teamName ?? "")
                    .font(.pretendard(.semiBold, size: 24))
                    .foregroundStyle(.black900)
                
                Text(viewModel.viewData?.goals ?? "")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.black500)
            }
            
            VStack(alignment: .leading, spacing: 14) {
                detailView(title: "카테고리", content: viewModel.viewData?.category ?? "")
                detailView(title: "목표금액", content: viewModel.viewData?.teamTargetAmount ?? "")
                detailView(title: "개인금액", content: viewModel.viewData?.personTargetAmound ?? "")
                detailView(title: "팀 유형", content: viewModel.viewData?.relationshipType ?? "")
                detailView(title: "기간", content: viewModel.viewData?.during ?? "")
                detailView(title: "팀 인원", content: viewModel.viewData?.memberCount ?? "")
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .rounded(radius: 12)
    }
    
    var description: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("챌린지 설명")
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(.black900)
            
            Text(viewModel.viewData?.description ?? "")
                .font(.pretendard(.regular, size: 14))
                .foregroundStyle(.black600)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .rounded(radius: 12)
    }
    

    private func detailView(title: String, content: String) -> some View {
        HStack(alignment: .center, spacing: 8){
            Text(title)
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(Color.black500)
                .frame(width: 55, alignment: .leading)
            
            Text(content)
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(Color.black900)
        }
    }
}

#Preview {
    let di = MockMainDIContainer()
    di.makeChallengeDetailView(challengeId: 1, coordinator: di.makeMainCoordinator())
}



