//
//  CreateChallengeView.swift
//  jjanpot
//
//  Created by 임주희 on 3/28/26.
//

import SwiftUI

// 챌린지 만들기
struct CreateChallengeView: View {
    
    @State var challengeName: String = ""
    @State var description: String = ""
    @State var selectedRelationshipType: RelationshipType? = nil
    
    // 멤버 유형, 인원
    @State var memberCountString: String = ""
    @State var memberCount: Double = 2.0
    
    // 챌린지 기간
    @State var startDate: Date? = Calendar.current.date(
        from: DateComponents(year: 2026, month: 7, day: 13)
    )
    @State var endDate: Date? = Calendar.current.date(
        from: DateComponents(year: 2026, month: 7, day: 19)
    )
   
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                messageBox
                    .padding(.top, 20)
                
                // 챌린지 이름
                challengeNameTextField
                
                // 챌린지 설명
                challengeDescription
                
                // 모집 인원, 유형
                memberType
                memberCountView
                
                
            }
            .padding(.horizontal, 20)
            
        }
        .navigationTitle("챌린지 만들기")
    }
    
    private var messageBox: some View {
        VStack (alignment: .leading, spacing: 6) {
            Text("새로운 절약 챌린지를 만들어 보세요.")
                .font(.pretendard(.medium, size: 14))
            Text("팀원들과 함께 목표를 정하고 절약을 시작해 보세요.")
                .font(.pretendard(.regular, size: 12))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 17)
        .background(Color.orange100)
        .rounded(radius: 12)
    }
    
    // 챌린지 이름
    private var challengeNameTextField: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView(title: "챌린지 이름",
                      description: "우리 챌린지의 이름을 입력해 주세요",
                      isNeccessary: true
            )
            
            TextField("", text: $challengeName, prompt:
                        Text("최대 14글자까지 입력해 주세요")
                .font(.pretendard(.regular, size: 14))
                .foregroundColor(Color.black200)
            )
            .font(.pretendard(.regular, size: 14))
            .foregroundColor(Color.black900)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .roundedBorder(color: .black100, radius: 12)
            .onChange(of: challengeName) { newValue in
                if newValue.count > 14 {
                    challengeName = String(newValue.prefix(14))
                }
            }
        }
    }
    
    // 챌린지 설명
    private var challengeDescription: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView(title: "챌린지 설명",
                      description: "팀원들과 공유할 메모를 남겨보세요.",
                      isNeccessary: false
            )
            
            
            ZStack(alignment: .topLeading) {
                // 1. 실제 입력창
                TextEditor(text: $description)
//                    .scrollContentBackground(.hidden)
//                    .background(Color.red)
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black900)
                    .onChange(of: description) { newValue in
                        if newValue.count > 80 {
                            challengeName = String(newValue.prefix(80))
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    
                
                // 2. 글자가 비어있을 때만 보여주는 Placeholder
                if description.isEmpty {
                    Text("최대 14글자까지 입력해 주세요")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color.black200)
                        .allowsHitTesting(false) // 중요: 터치 이벤트가 뒤의 TextEditor로 전달되게 함
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                }
            }
            .frame(height: 104)
            .roundedBorder(color: .black100, radius: 12)
        }
    }
    
    private var memberType: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView(title: "모집 인원, 유형",
                      description: "누구와 함께, 몇 명이 챌린지에 참여하나요?",
                      isNeccessary: true
            )
            GridSingleSelector(selectedItem: $selectedRelationshipType, columns: 3)
        }
    }
    
    // 모집인원
    private var memberCountView: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("", text: $memberCountString, prompt:
                        Text("최대 8")
                .font(.pretendard(.regular, size: 14))
                .foregroundColor(Color.black200)
            )
            .font(.pretendard(.regular, size: 14))
            .foregroundColor(Color.black900)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(width: 100)
            .roundedBorder(color: .black100, radius: 12)
//            .onChange(of: memberCountString) { newValue in
//                let count = Int(newValue) ?? 0
//                if count > 8 {
//                    memberCount = 8
//                } else if count < 2 {
//                    memberCount = 2
//                }
//                memberCountString = "\(memberCount)"
//            }
            .overlay(alignment: .trailing) {
                Text("명")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black900)
                    .padding(.trailing, 20)
                    .allowsHitTesting(false)
            }
            
            VStack(spacing: 5) {
                Slider(
                    value: $memberCount,
                    in: 2...8,      // 2에서 8까지 범위 제한
                    step: 1         // 1 단위로 이동 (정수 선택)
                )
                .tint(Color.orange500)
                
                HStack {
                    Text("2")
                        .font(.pretendard(.medium, size: 12))
                    Spacer()
                    Text("8")
                        .font(.pretendard(.medium, size: 12))
                }
                .foregroundStyle(Color.black500)
            }
        }
    }
    
    // 챌린지 기간
    private func challengeDurationView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleView(title: "챌린지 기간",
                      description: "언제부터 챌린지를 시작할까요?(일주일동안 진행돼요.)",
                      isNeccessary: true
            )
            
            RangeCalendarView(
                startDate: $startDate,
                endDate: $endDate,
                rangeDays: 7
            )
            
            
        }
    }
    
    
}



#Preview {
    CreateChallengeView()
}
