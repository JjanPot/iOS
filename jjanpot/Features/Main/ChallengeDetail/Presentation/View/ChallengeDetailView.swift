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
    init(viewModel: ChallengeDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
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

//#Preview {
//    ChallengeDetailView(viewModel: )
//}



