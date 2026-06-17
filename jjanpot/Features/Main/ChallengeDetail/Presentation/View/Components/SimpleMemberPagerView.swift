//
//  SimpleMemberPagerView.swift
//  jjanpot
//
//  Created by 임주희 on 4/18/26.
//

import SwiftUI
import UIKit

struct SimpleMemberPagerView: View {
    let members: [MemberCardViewData]
    let onSelect: (MemberCardViewData) -> Void

    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - 80 // 양쪽 버튼 공간 제외
            let spacing: CGFloat = 8
            // 4개 표시 시 필요한 총 너비 계산
            let fourMembersWidth = calculateTotalWidth(for: 4, spacing: spacing)
            let visibleCount = fourMembersWidth <= availableWidth ? 4 : 3

            HStack(alignment: .top, spacing: spacing) {

                // 왼쪽 버튼
                Button(action: {
                    moveLeft()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(isLeftDisabled(visibleCount) ? .black300 : .black900)
                        .padding(.trailing, 8)
                }
                .disabled(isLeftDisabled(visibleCount))
                .frame(maxHeight: .infinity)

                // 이미지 영역
                HStack(alignment: .top, spacing: spacing) {
                    ForEach(visibleMembers(visibleCount).indices, id: \.self) { index in
                        Button {
                            onSelect(visibleMembers(visibleCount)[index])
                        } label: {
                            SimpleMemberCardView(viewData: visibleMembers(visibleCount)[index])
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .disabled(true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)


                // 오른쪽 버튼
                Button(action: {
                    moveRight(visibleCount)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(isRightDisabled(visibleCount) ? .black300 : .black900)
                        .padding(.leading, 8)

                }
                .disabled(isRightDisabled(visibleCount))
                .frame(maxHeight: .infinity)

            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .frame(height: 26)
    }
}

// MARK: - Computed
private extension SimpleMemberPagerView {

    func visibleMembers(_ visibleCount: Int) -> [MemberCardViewData] {
        guard !members.isEmpty else { return [] }

        let safeIndex = min(currentIndex, max(members.count - visibleCount, 0))
        let end = min(safeIndex + visibleCount, members.count)

        return Array(members[safeIndex..<end])
    }

    func isLeftDisabled(_ visibleCount: Int) -> Bool {
        currentIndex <= 0
    }

    func isRightDisabled(_ visibleCount: Int) -> Bool {
        currentIndex + visibleCount >= members.count
    }

    /// 현재 보여줄 멤버들의 카드 총 너비 계산
    func calculateTotalWidth(for count: Int, spacing: CGFloat) -> CGFloat {
        let membersToShow = visibleMembers(count)
        let font = UIFont.systemFont(ofSize: 12, weight: .medium)
        let imageWidth: CGFloat = 26
        let imageToTextSpacing: CGFloat = 6

        var totalWidth: CGFloat = 0
        for member in membersToShow {
            let textWidth = (member.nickname as NSString).size(withAttributes: [.font: font]).width
            let cardWidth = imageWidth + imageToTextSpacing + textWidth
            totalWidth += cardWidth
        }
        // 카드 사이 간격 추가
        totalWidth += CGFloat(membersToShow.count - 1) * spacing

        return totalWidth
    }
}

// MARK: - Action
private extension SimpleMemberPagerView {

    func moveLeft() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }

    func moveRight(_ visibleCount: Int) {
        guard currentIndex + visibleCount < members.count else { return }
        currentIndex += 1
    }
}

#Preview {
    SimpleMemberPagerView(members: [
        .init(userId: 0, nickname: "닉네임닉네임0", imageUrl: "", color: .red, amount: 10000, isMe:  true ,isLeader: true, isBlocked: false),
        .init(userId: 1, nickname: "닉네임2닉네임", imageUrl: "", color: .black, amount: 12000, isMe:  false, isLeader: false, isBlocked: false),
        .init(userId: 2, nickname: "네임3", imageUrl: "", color: .blue, amount: 13000, isMe:  false, isLeader: false, isBlocked: false),
        .init(userId: 3, nickname: "네임4", imageUrl: "", color: .green, amount: 14000, isMe:  false, isLeader: false, isBlocked: false),
        
            .init(userId: 4, nickname: "네임5", imageUrl: "", color: .purple, amount: 14000, isMe:  false, isLeader: false, isBlocked: false),
        .init(userId: 5, nickname: "닉네6", imageUrl: "", color: .teal, amount: 14000, isMe:  false, isLeader: false, isBlocked: false),
        .init(userId: 6, nickname: "닉네", imageUrl: "", color: .yellow, amount: 14000, isMe:  false, isLeader: false, isBlocked: false),
    ], onSelect: { _ in })
    .padding(20)
}
