//
//  ChallengeGuideLine.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//

import SwiftUI

// 챌린지 가이드라인 (하드코딩뷰)
struct ChallengeGuideLine: View {
    
    @State var isExpanded: Bool = false
    @State var isExpanded2: Bool = false
    @State var isExpanded3: Bool = false
    @State var isExpanded4: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("챌린지 가이드라인 안내")
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(.black900)
            
            VStack(alignment: .leading, spacing: .zero){
                CustomDisclosureGroup(isExpanded: $isExpanded) {
                    Text("절약 금액 계산 안내")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.black600)
                        .padding(.vertical, 18)
                } content: {
                    VStack (alignment: .leading, spacing: 30){
                        VStack (alignment: .leading, spacing: .zero){
                            Text("1. 소비를 안 했다면")
                                .font(.pretendard(.light, size: 12))
                                .foregroundStyle(.black900)
                            Text(
                            """
                            해당 카테고리 기준 금액만큼 절약돼요.\n
                            예) 카페 4,500원 / 오늘 카페 안 감 → +4,500원 절약
                            """
                            )
                            .font(.pretendard(.light, size: 12))
                            .foregroundStyle(.black900)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        VStack (alignment: .leading, spacing: .zero){
                            Text("2. 더 저렴하게 소비했다면")
                                .font(.pretendard(.light, size: 12))
                                .foregroundStyle(.black900)
                            Text(
                            """
                            기준 금액과의 차액이 절약 금액이에요.
                             예) 카페 4,500원 / 저가 커피 2,000원 → +2,500원 절약
                            """
                            )
                            .font(.pretendard(.light, size: 12))
                            .foregroundStyle(.black900)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        
                        VStack (alignment: .leading, spacing: .zero){
                            Text("3. 기준보다 비싸다면")
                                .font(.pretendard(.light, size: 12))
                                .foregroundStyle(.black900)
                            Text(
                            """
                            절약 금액은 -4500원이에요
                            예) 카페 4,500원 / 오션뷰 카페 9,000원 → 절약 -4,500원
                            """
                            )
                            .font(.pretendard(.light, size: 12))
                            .foregroundStyle(.black900)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background { Color.black50 }
                    .rounded(radius: 10)
                }
                thinLine
                
                // MARK: 개인 인증 규칙
                CustomDisclosureGroup(isExpanded: $isExpanded2) {
                    Text("개인 인증 규칙")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.black600)
                        .padding(.vertical, 18)
                } content: {
                    VStack (alignment: .leading, spacing: 4){
                        DotText("한 주에 2회 이상 인증해야 돼요.")
                        DotText("하루 3회 초과 인증은 금지돼요.")
                        DotText("개인 최소 목표 금액은 5,000원, 최대 목표 금액은 300,000원으로 제한돼요.")
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background { Color.black50 }
                    .rounded(radius: 10)
                    .fixedSize(horizontal: false, vertical: true)
                    
                }
                thinLine
                
                // MARK: 팀 인증 규칙
                CustomDisclosureGroup(isExpanded: $isExpanded3) {
                    Text("팀 인증 규칙")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.black600)
                        .padding(.vertical, 18)
                } content: {
                    VStack (alignment: .leading, spacing: 4){
                        
                        DotText("챌린지 기간 내 인당 최소 절약 목표 금액을 충족해야 돼요.")
                        
                        DotText("팀 최대 목표 금액은 300만원으로 제한돼요.")
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background { Color.black50 }
                    .rounded(radius: 10)
                }
                thinLine
                
                // MARK: 패널티
                CustomDisclosureGroup(isExpanded: $isExpanded4) {
                    Text("패널티")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.black600)
                        .padding(.vertical, 18)
                } content: {
                    VStack(alignment: .leading, spacing: 30) {
                        VStack (alignment: .leading, spacing: 4){
                            DotText("팀 성공 여부와 상관없이 주간 인증 1회 이하 or 하루 3회 초과 인증하면 개인은 목표 달성에서 제외돼요. ")
                            DotText("팀원 전원이 개인 최소 금액을 충족해야 해요.")
                        }
                        
                        VStack (alignment: .leading, spacing: 11){
                            Text("결과 기준")
                                .font(.pretendard(.medium, size: 10))
                                .foregroundStyle(.black900)
                            
                            Grid(alignment: .leading,verticalSpacing: 8) {
                                GridRow {
                                    Text("개인 최소 금액")
                                        .font(.pretendard(.medium, size: 8))
                                    
                                    Text("팀 공동 목표")
                                        .font(.pretendard(.medium, size: 8))
                                    
                                    Text("결과")
                                        .font(.pretendard(.medium, size: 8))
                                }
                                
                                Color.black500
                                    .frame(height: 0.5)
                                
                                threeGridRow("충족","충족","성공")
                                threeGridRow("충족","미충족","실패")
                                threeGridRow("미충족","충족","실패")
                                threeGridRow("미충족","미충족","실패")
                            }
                            
                            
                            .padding(4.5)
                            
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background { Color.white }
                        .padding(10)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background { Color.black50 }
                    .rounded(radius: 10)
                }
                
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .rounded(radius: 12)

    }
    
    private var thinLine: some View {
        Color.black100.opacity(0.4)
            .frame(height: 1)
    }
    
    private func DotText(_ content: String) -> some View {
        HStack(alignment: .top, spacing: 4) {
            Circle()
                .fill(Color.black900)
                .frame(width: 1, height: 1, alignment: .center)
                .padding(.vertical, 7)
            Text(content)
                .font(.pretendard(.light, size: 12))
                .foregroundStyle(.black900)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func threeGridRow(_ text1: String, _ text2: String, _ text3: String) -> some View {
        GridRow {
            Text(text1)
                .font(.pretendard(.light, size: 8))
            
            Text(text2)
                .font(.pretendard(.light, size: 8))
            
            Text(text3)
                .font(.pretendard(.light, size: 8))
        }
    }
}

#Preview {
    ChallengeGuideLine()
}
