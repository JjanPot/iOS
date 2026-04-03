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
            VStack(alignment: .leading, spacing: 40) {
                MainHeader(type: .setting) {
                    coordinator.push(.settings)
                }
                
                Group {
                    profill
                    
            
                    
                   
                    
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



#Preview {
    let di = MockMyPageDIContainer()
    di.makeMyPotView(coordinator: di.makeMyPageCoordinator())
}





