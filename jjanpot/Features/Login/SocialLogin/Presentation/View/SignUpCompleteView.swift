//
//  SignUpComplete.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

struct SignUpCompleteView: View {
    let onNavigateToMain: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            
            Spacer()
            VStack (alignment: .center, spacing: 18){
                Text("혼자서는 어려운 절약,\n같이하면 쉬워요!")
                    .font(.pretendard(.semiBold, size: 24))
                    .foregroundStyle(Color.orange500)
                    .multilineTextAlignment(.center)
                
                Text("친구들과 함께 절약을 공유하고\n서로 응원하며 동기부여 받아요.")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(Color.black800)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 74)
            
            Image("signupComplete")
                .resizable()
                .frame(width: 306, height: 202)
            
            Spacer()
            MainButton(title: "시작하기") {
                onNavigateToMain()
            }
            .padding()
        }
    }
}

#Preview {
    SignUpCompleteView(onNavigateToMain: {
        print("Navigate to main")
    })
}
