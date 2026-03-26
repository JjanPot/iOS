//
//  HomeView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        // TODO: 메세지 변경
        @State var teamMessage = "목표를 만들고\n팀고 함께 절약해요!"
        
        VStack(spacing: .zero) {
            // 헤더
            HStack {
                Image("TextLogo")
                    .resizable()
                    .frame(width: 122, height: 18.49)
                Spacer()
                
                // TODO: 알람버튼
                
                    
            }
            .padding(20)
            
            // 내용물
            ScrollView {
                VStack(spacing: 20){
                    
                    HStack {
                        Text(teamMessage)
                            .font(.pretendard(.medium, size: 20))
                            .foregroundStyle(.black900)
                        
                        Spacer()
                        
                        Image("charater")
                            .resizable()
                            .frame(width: 76.73, height: 72)
                    }
                    .padding(.horizontal, 20)
                    
                    // 챌린지 카드
                    
                    
                    
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
