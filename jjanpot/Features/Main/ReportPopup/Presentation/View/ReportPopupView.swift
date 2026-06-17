//
//  ReportPopupView.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//

import SwiftUI

struct ReportPopupView: View {
    let challengeId: Int
    let comfirmAction: () -> Void
    let closeAction: () -> Void

    
    init(challengeId: Int, comfirmAction: @escaping () -> Void, closeAction: @escaping () -> Void) {
        self.challengeId = challengeId
        self.comfirmAction = comfirmAction
        self.closeAction = closeAction
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 42){
            VStack(alignment: .center, spacing: 26){
                
                Color.black100
                    .frame(width: 60, height: 4)
                    .clipShape(Capsule())
                
                VStack(alignment: .center, spacing: 3){
                    Text("완료된 챌린지가 있어요")
                        .font(.pretendard(.semiBold, size: 20))
                        .foregroundStyle(Color.black900)
                    Text("결과지를 보러 갈까요")
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(Color.black400)
                }
                
                Image("success")
                       
            }
            VStack(alignment: .center, spacing: 12){
                MainButton(title: "결과 확인") {
                    comfirmAction()
                }
                Button {
                    Task {
                        AppConfig.shared.latestCompletedChallengeId = challengeId
                    }
                    closeAction()
                    
                } label: {
                    Text("다시 보지 않기")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(Color.black400)
                }
            }

        }
        .padding()
        .background(Color.white)
        .rounded(radius: 12)

    }
}

#Preview {
    ReportPopupView(challengeId: 1, comfirmAction: {}, closeAction: {})
}
