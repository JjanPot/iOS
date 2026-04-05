//
//  ChallengeHistoryView.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//

import SwiftUI


struct ChallengeHistoryView: View {
    
    @StateObject var viewModel: ChallengeHistoryViewModel
    private let coordinator: MainCoordinator
    
    init(viewModel: ChallengeHistoryViewModel, coordinator: MainCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    
    var body: some View {
        
        Group {
            if viewModel.viewDatas.isEmpty {
                
                VStack (alignment: .center, spacing: 15){
                    
                    Spacer()
                    Image("nodata")
                        .resizable()
                        .frame(width: 124, height: 124)
                        
                    Text("완료된 챌린지가 없어요")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.black500)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 11)
                        .background(Color.white)
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.orange50)
                
                
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.viewDatas) { viewData in
                            Button {
                                coordinator.push(.challengeReport(id: viewData.id))
                            } label: {
                                ChallengeHistoryCardView(
                                    viewData: viewData
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .task {
            viewModel.loadHistories()
        }
    }
}

#Preview {
//    ChallengeHistoryView()
}
