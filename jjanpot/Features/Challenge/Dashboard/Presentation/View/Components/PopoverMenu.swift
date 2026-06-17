//
//  PopoverMenu.swift
//  jjanpot
//
//  Created by 임주희 on 4/10/26.
//


import SwiftUI

struct PopoverMenu: View {
    let items: [MenuItem]
    @Binding var isPresented: Bool

    struct MenuItem: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let isDestructive: Bool
        let action: () -> Void

        init(title: String, icon: String, isDestructive: Bool = false, action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.isDestructive = isDestructive
            self.action = action
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button {
                    item.action()
                    isPresented = false
                } label: {
                    HStack(spacing: .zero) {

                        Text(item.title)
                            .font(.pretendard(.medium, size: 16))
                            .foregroundStyle(item.isDestructive ? Color.red : Color.black600)

                        Spacer()

                        Image(item.icon)

                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 5.5)
        .padding(.vertical, 6)
        .frame(maxWidth: 140)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)

    }
}

#Preview {
    ZStack {
        //Color.white.ignoresSafeArea()

        VStack {
            Spacer()
            PopoverMenu(
                items: [
                    .init(title: "게시물 신고", icon: "icon_alert_triangle") { print("수정") },
                    .init(title: "사용자 신고", icon: "icon_alert_triangle") { print("수정") },
                    .init(title: "사용자 차단", icon: "icon_frown", isDestructive: false) { print("삭제") }
                    
                ],
                isPresented: .constant(true)
            )
            .padding()
            Spacer()
        }
    }
}
