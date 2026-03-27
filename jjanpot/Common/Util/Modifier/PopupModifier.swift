//
//  PopupModifier.swift
//  jjanpot
//
//  Created by 임주희 on 3/27/26.
//


import SwiftUI

struct PopupModifier<PopupContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let popupContent: () -> PopupContent
    let onDismiss: (() -> Void)?

    func body(content: Content) -> some View {
        ZStack {

            content

            // 배경
            Color.black.opacity(isPresented ? 0.3 : 0)
                .ignoresSafeArea()
                .allowsHitTesting(isPresented)

            // 팝업
            popupContent()
                .padding(.horizontal, 30)
                .scaleEffect(isPresented ? 1.0 : 0.8)
                .opacity(isPresented ? 1.0 : 0)
                .allowsHitTesting(isPresented)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(
            isPresented
                ? .spring(response: 0.3, dampingFraction: 0.8)
                : .easeOut(duration: 0.2),
            value: isPresented
        )
        .onChange(of: isPresented) { newValue in
            if !newValue {
                onDismiss?()
            }
        }
    }
}

extension View {
    func popup<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(PopupModifier(isPresented: isPresented, popupContent: content, onDismiss: onDismiss))
    }

    /// 메시지 기반 팝업 (toast처럼 message가 있을 때만 자동으로 표시)
    func popup(message: Binding<String?>) -> some View {
        self.popup(
            isPresented: Binding(
                get: { message.wrappedValue != nil },
                set: { if !$0 { message.wrappedValue = nil } }
            )
        ) {
            if let msg = message.wrappedValue {
                Modal(title: msg, content: nil)
                    .buttons {
                        MainButton(title: "확인", size: .large, colorType: .fill) {
                            message.wrappedValue = nil
                        }
                    }
            }
        }
    }
}
