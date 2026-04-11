//
//  MemberPagerView.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI

struct MemberPagerView: View {
    let members: [MemberCardViewData]
    
    private let visibleCount = 4
    @State private var currentIndex: Int = 0
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            
            // 왼쪽 버튼
            Button(action: {
                moveLeft()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(isLeftDisabled ? .black300 : .black900)
                    .padding(.trailing, 8)
            }
            .disabled(isLeftDisabled)
            .frame(maxHeight: .infinity)
            
            // 이미지 영역
            HStack(alignment: .top, spacing: 8) {
                ForEach(visibleMembers.indices, id: \.self) { index in
                    MemberCardView(viewData: visibleMembers[index])
                        .frame(maxWidth: .infinity)
                    
                }
            }
            
            // 오른쪽 버튼
            Button(action: {
                moveRight()
            }) {
                Image(systemName: "chevron.right")
                    .foregroundStyle(isRightDisabled ? .black300 : .black900)
                    .padding(.leading, 8)
                
            }
            .disabled(isRightDisabled)
            .frame(maxHeight: .infinity)
            
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Computed
private extension MemberPagerView {
    
    var visibleMembers: [MemberCardViewData] {
        guard !members.isEmpty else { return [] }
        
        let safeIndex = min(currentIndex, max(members.count - visibleCount, 0))
        let end = min(safeIndex + visibleCount, members.count)
        
        return Array(members[safeIndex..<end])
    }
    
    var isLeftDisabled: Bool {
        currentIndex <= 0
    }
    
    var isRightDisabled: Bool {
        currentIndex + visibleCount >= members.count
    }
}

// MARK: - Action
private extension MemberPagerView {
    
    func moveLeft() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }
    
    func moveRight() {
        guard currentIndex + visibleCount < members.count else { return }
        currentIndex += 1
    }
}

#Preview {
    MemberPagerView(members: [
        .init(userId: 0, nickname: "닉네임0", imageUrl: "", color: .red, amount: 10000, isLeader: true, isBlocked: false),
        .init(userId: 0, nickname: "닉네임2닉네임", imageUrl: "", color: .black, amount: 12000, isLeader: true, isBlocked: false),
        .init(userId: 0, nickname: "닉네임3", imageUrl: "", color: .blue, amount: 13000, isLeader: true, isBlocked: false),
        .init(userId: 0, nickname: "닉네임4", imageUrl: "", color: .green, amount: 14000, isLeader: true, isBlocked: false),
             ])
    .padding(20)
}
