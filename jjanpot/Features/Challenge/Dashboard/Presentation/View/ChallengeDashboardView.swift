//
//  ChallengeDashboardView.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//

import SwiftUI



// 챌린지 대시보드
struct ChallengeDashboardView: View {
    @StateObject var viewModel: ChallengeDashboardViewModel
    private let coordinator: MainCoordinator
    
    
    
    init(viewModel: ChallengeDashboardViewModel, coordinator: MainCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: .zero){
            VStack (alignment: .center, spacing: .zero){
                MainHeader()
                
                if true {
                    overview
                } else {
                    emptyOverview
                }
                
            }
            .background(Color.orange50)
                ScrollView {
                    VStack (alignment: .leading, spacing: .zero){
                    
                        HStack() {
                            Spacer()
                            Text("모든 게시글")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundStyle(.black500)
                                .padding(.top, 24)
                            Spacer()
                        }
                        .padding(.bottom, 24)
                        
                        
                        FeedHeaderView()
                        FeedCardView(viewData: FeedCardViewData(
                            category: "카페/디저트",
                            title: "오므라이스 최고",
                            content: "텀블러에 담아서 먹었는데 그럭저럭 먹을만하더라구요. 다들 맛있게 절약하세요.",
                            price: "+3,500원",
                            likeCount: 3,
                            date: "2027.09.18 18:30"
                        ))
                    
                }
                    .padding(.horizontal, 20)
            }
        }
    }
    
    
    private var overview: some View {
        VStack (alignment: .center, spacing: .zero){
            
            Text("카페는 이제 그만!")
                .font(.pretendard(.semiBold, size: 24))
                .foregroundStyle(.black)
                .padding(.bottom, 20)
            
            Text("7월 15일부터 현재까지 절약금액")
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.black700)
                .padding(.bottom, 15)
            
            HStack (alignment: .bottom, spacing: .zero){
                Text("261,000원 ")
                    .font(.pretendard(.semiBold, size: 26))
                    .foregroundStyle(.black)
                Text("/ 300,000원")
                    .font(.pretendard(.medium, size: 15))
                    .foregroundStyle(.black500)
            }
            
            SegmentedBar(
                segments: [
                    .init(ratio: 0.2, color: .red),
                    .init(ratio: 0.25, color: .orange),
                    .init(ratio: 0.15, color: .yellow),
                    .init(ratio: 0.3, color: .brown),
                    .init(ratio: 0.1, color: .black)
                ]
            )
            .padding(.vertical, 16)
            
            
            // 유저 목록
            MemberPagerView(members: viewModel.members)
            
        }
        .padding([.horizontal, .bottom],20)
    }
    
    private var emptyOverview: some View {
        VStack (alignment: .center, spacing: 15){
            Image("nodata")
                .resizable()
                .frame(width: 124, height: 124)
                
            Text("아직 챌린지가 없어요")
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.black500)
                .padding(.vertical, 8)
                .padding(.horizontal, 11)
                .background(Color.white)
                .clipShape(Capsule())
        }
        .padding(.vertical, 70)
    }
}

#Preview {
    let di = MockMainDIContainer()
    di.makeChallengeDashboardView(coordinator: di.makeMainCoordinator())
}
