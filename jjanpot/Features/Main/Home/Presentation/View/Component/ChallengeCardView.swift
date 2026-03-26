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
        .fixedSize(horizontal: true, vertical: false)
    }
}

// MARK: 챌린지 없음 (여긴 하드코딩)
struct ChallengeNoneView : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            
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
                    .foregroundStyle(Color.black500)
            }
            // spacing: 28
            
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

// MARK: 챌린지 대기
struct ChallengePendingView : View {
    
    // 팀 목표금액
    let targetSavingsAmount = 30
    
    // 기간 "26.07.15 - 16.07.21 (1주)"
    let period: String = "26.07.15 - 16.07.21 (1주)"
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .leading, spacing: 8) {
                // 챌린지 상태
                BadgeView(title: "대기중인 챌린지")
                
                // 팀이름
                Text("챌린지를 시작해보세요!")
                    .font(.pretendard(.semiBold, size: 26))
                    .foregroundColor(.black500)
                
                // TODO: 부제
                (
                    Text("\(targetSavingsAmount)만원")
                    .foregroundColor(.black700)
                 + Text(" 목표로 ")
                        .foregroundColor(.black500)
                 + Text("1주")
                    .foregroundColor(.black700)
                 + Text(" 동안 함께 절약하기")
                        .foregroundColor(.black500)
                )
                .font(.pretendard(.medium, size: 14))
                
                // waiting - 챌린지 기간
                Text(period)
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(Color.black600)
            }
            // spacing: 20
            
            // 상세정보 버튼 (두개)
            HStack(spacing: 10){
                CapsuleButton(title: "상세정보", colorType: .border, isDisabled: false){
                    print(">>>>> 상세정보")
                }
                CapsuleButton(title: "초대코드 복사", colorType: .fill, isDisabled: false){
                    print(">>>>> 초대코드 복사")
                }
            }
            
        }
    }
}

// MARK: 챌린지 진행중
struct ChallengeInProgressView : View {
    // 남은 기간
    let dday = 3
    
    // 팀절약금액
    let teamSavingsAmount = "250,000원"
    // 개인절약금액
    let personalSavingsAmount = "25,000원"
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            VStack(alignment: .leading, spacing: 8) {
                // 챌린지 상태
                BadgeView(title: "종료일까지 D-\(dday)")
                
                // 팀이름
                Text("챌린지를 시작해보세요!")
                    .font(.pretendard(.semiBold, size: 26))
                    .foregroundStyle(Color.black900)
                
                // in Progress - 절액금액
                HStack {
                    Text("팀 절약")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(Color.black500)
                    Spacer()
                    Text(teamSavingsAmount)
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(Color.orange600)
                }
                HStack {
                    Text("개인 절약")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(Color.black500)
                    Spacer()
                    Text(personalSavingsAmount)
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(Color.black900)
                    
                }
            }
            // spacing: 18
            
            // 상세정보 버튼 (두개)
            HStack(spacing: 10){
                CapsuleButton(title: "상세 정보", colorType: .border, isDisabled: false){
                    print(">>>>> 챌린지 상세 정보")
                }
                CapsuleButton(title: "인증하기", colorType: .fill, isDisabled: false){
                    print(">>>>> 인증하기 화면띄우기")
                }
            }
        }
    }
}



#Preview {
    ChallengeCardView(status: .none)
    ChallengeCardView(status: .waiting)
    ChallengeCardView(status: .inProgress)
}
