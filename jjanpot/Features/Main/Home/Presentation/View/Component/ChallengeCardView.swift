//
//  ChallengeCard.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

enum ChallengeStatus {
    // 없음
    case none
    // 대기중
    case waiting
    // 챌린지 진행중
    case inProgress
}



struct ChallengeCardView: View {
    let status: ChallengeStatus
    var body: some View {
        VStack {
            switch status {
            case .none:
                ChallengeNoneView()
            case .waiting:
                ChallengePendingView()
            case .inProgress:
                ChallengeInProgressView()
            }
            
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(Color.orange100)
        .rounded(radius: 12)
        .roundedBorder(color: .orange300, radius: 12)
    }
}

// 챌린지 없음 (여긴 하드코딩해도 될듯)
struct ChallengeNoneView : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            VStack(alignment: .leading, spacing: 8) {
                // 챌린지 상태
                BadgeView(title: "대기중인 챌린지 없음")
                
                // 팀이름
                Text("챌린지를 시작해보세요!")
                    .font(.pretendard(.semiBold, size: 26))
                    .foregroundStyle(Color.black900)
                
                // 부제
                Text("새로운 챌린지를 만들거나 초대를 받아보세요")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundStyle(Color.orange500)
                    .padding(.bottom, 25)
                
                // waiting - 챌린지 기간
                
                // in Progress - 절액금액
            }
            // spacing: 18
            
            // 프로그레스바 + 상세정보 버튼 (두개)
            VStack(alignment: .leading, spacing: 10) {
                // 프로그레스바
                
                // spacing: 10
                
                // 상세정보 버튼 (두개)
                HStack(spacing: 10){
                    CapsuleButton(title: "챌린지 만들기", colorType: .border, isDisabled: false){
                        print(">>>>> 챌린지 만들기")
                    }
                    CapsuleButton(title: "초대코드 입력", colorType: .fill, isDisabled: false){
                        print(">>>>> 초대코드 입력")
                    }
                }
                
            }
            
        }
    }
}
struct ChallengePendingView : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 챌린지 상태
            BadgeView(title: "대기중인 챌린지 없음")
            
            // 팀이름
            Text("챌린지를 시작해보세요!")
                .font(.pretendard(.semiBold, size: 26))
                .foregroundStyle(Color.black900)
            
            // 부제
            
            // 챌린지 기간
            
            // 절액금액
            
            // 프로그레스바
            
            // 상세정보 버튼 (두개)
        }
    }
}
struct ChallengeInProgressView : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 챌린지 상태
            BadgeView(title: "대기중인 챌린지 없음")
            
            // 팀이름
            Text("챌린지를 시작해보세요!")
                .font(.pretendard(.semiBold, size: 26))
                .foregroundStyle(Color.black900)
            
            // 부제
            
            // 챌린지 기간
            
            // 절액금액
            
            // 프로그레스바
            
            // 상세정보 버튼 (두개)
        }
    }
}



#Preview {
    ChallengeCardView(status: .none)
    ChallengeCardView(status: .waiting)
    ChallengeCardView(status: .inProgress)
}
