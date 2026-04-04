//
//  MyPotView.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//

import SwiftUI
import Kingfisher

struct MyPotView: View {
    
    @StateObject var viewModel: MyPotViewModel
    private let coordinator: MyPageCoordinator
    
    init(viewModel: MyPotViewModel, coordinator: MyPageCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                MainHeader(type: .setting) {
                    coordinator.push(.settings)
                }
                
                Group {
                    profill
                    
                    // 챌린지 참여 현황
                    if let viewData = viewModel.myStatsViewData {
                        HStack {
                            MyChallengeStatsItemView(.totalChallenge, content: viewData.totalCount)
                            Spacer()
                            MyChallengeStatsItemView(.success, content: viewData.successCount)
                            Spacer()
                            MyChallengeStatsItemView(.failed, content: viewData.failCount)
                            Spacer()
                            MyChallengeStatsItemView(.successRate, content: viewData.successRate)
                            
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .roundedBorder(color: .orange400, radius: 12)
                    }
                    
                    
                    // 챌린지 리포트 보기
                    Button("챌린지 리포트 보기"){
                        coordinator.push(.challengeReport(challengeId: 6))
                    }
                    
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        } //ScrollView
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .task {
            viewModel.loadUserInfo()
            viewModel.getMyChallengeStats()
        }
    }
    
    private var profill: some View {
        HStack(alignment: .center, spacing: 14) {
            Group {
                if let imageUrl = viewModel.profileViewData?.imageUrl {
                    KFImage(URL(string: imageUrl))
                        .placeholder {
                            placeholder
                        }
                        .retry(maxCount: 3, interval: .seconds(2))
                        .onFailure { error in
                            Logger.error("Image load failed: \(error.localizedDescription)")
                        }
                        .fade(duration: 0.25)
                        .resizable()
                        .scaledToFill()
                } else {
                    placeholder
                }
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            
            
            Text(viewModel.profileViewData?.nickname ?? "")
                .font(.pretendard(.semiBold, size: 16))
                .foregroundStyle(Color.black900)
            
        }
    }
    private var placeholder: some View {
        Color.black100
            .overlay(alignment: .center) {
                Image("person")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
//            .frame(width: 44, height: 44)
//            .clipShape(Circle())
    }
}

#Preview {
    let di = MockMyPageDIContainer()
    di.makeMyPotView(coordinator: di.makeMyPageCoordinator())
}



