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
                    
                    HStack {
                        MyChallengeSummaryItemView(.totalChallenge, content: "10")
                        Spacer()
                        MyChallengeSummaryItemView(.success, content: "3")
                        Spacer()
                        MyChallengeSummaryItemView(.failed, content: "7")
                        Spacer()
                        MyChallengeSummaryItemView(.successRate, content: "10%")
                        
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .roundedBorder(color: .orange400, radius: 12)
                    
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        } //ScrollView
    }
    
    private var profill: some View {
        HStack(alignment: .center, spacing: 14) {
            placeholder
            Text("nickname")
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
            .frame(width: 44, height: 44)
            .clipShape(Circle())
    }
}

struct MyChallengeSummaryItemView : View{
    enum MyChallengeSummaryItemViewType {
        case totalChallenge
        case success
        case failed
        case successRate
        
        var image: String {
            switch self {
            case .totalChallenge:
                return "cup"
            case .success:
                return "smile"
            case .failed:
                return "sad"
            case .successRate:
                return "fire"
            }
        }
        
        var title: String {
            switch self {
            case .totalChallenge:
                return "총 챌린지"
            case .success:
                return "성공"
            case .failed:
                return "실패"
            case .successRate:
                return "성공률"
            }
        }
    }
    let viewType: MyChallengeSummaryItemViewType
    let content: String
    init(_ viewType: MyChallengeSummaryItemViewType, content: String) {
        self.viewType = viewType
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Image(viewType.image)
                .frame(width: 30, height: 30)
            
            Text(viewType.title)
                .font(.pretendard(.regular, size: 12))
                .foregroundStyle(.black600)
            Text(content)
                .font(.pretendard(.semiBold, size: 20))
                .foregroundStyle(.black)
        }
        
    }
    
}



#Preview {
    let di = MockMyPageDIContainer()
    di.makeMyPotView(coordinator: di.makeMyPageCoordinator())
}





