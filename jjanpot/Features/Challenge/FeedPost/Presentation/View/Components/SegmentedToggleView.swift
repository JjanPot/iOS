//
//  SegmentedToggleView.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//


import SwiftUI

struct SegmentedToggleView: View {
    
    @Binding var selectedTab: FeedPostTab
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            tabButton(title: "지출", tab: .expense)
            tabButton(title: "무지출", tab: .noExpense)
        }
        .frame(height: 48)
        .padding(2)
        .background(Color.black100)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedTab)
    }
    
    private func tabButton(title: String, tab: FeedPostTab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            ZStack {
                if selectedTab == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .matchedGeometryEffect(id: "background", in: animation)
                }
                
                Text(title)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(selectedTab == tab ? .black900 : .black500)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .contentShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    SegmentedToggleView(selectedTab: .constant(.expense))
}
