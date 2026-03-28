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
    let dismissOnBackgroundTap: Bool

    func body(content: Content) -> some View {
        ZStack {

            content

            // 배경
            Color.black.opacity(isPresented ? 0.3 : 0)
                .ignoresSafeArea()
                .allowsHitTesting(isPresented)
                .onTapGesture {
                    if dismissOnBackgroundTap {
                        isPresented = false
                    }
                }

            // 팝업
            popupContent()
                .padding(.horizontal, 20)
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
                // 닫기 애니메이션 완료 후 onDismiss 호출 (0.2초 easeOut 대기)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    onDismiss?()
                }
            }
        }
    }
}

extension View {
    func popup<Content: View>(
        isPresented: Binding<Bool>,
        dismissOnBackgroundTap: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(PopupModifier(isPresented: isPresented, popupContent: content, onDismiss: onDismiss, dismissOnBackgroundTap: dismissOnBackgroundTap))
    }

    /// 메시지 기반 팝업 (toast처럼 message가 있을 때만 자동으로 표시)
    func popup(message: Binding<String?>, dismissOnBackgroundTap: Bool = true) -> some View {
        self.popup(
            isPresented: Binding(
                get: { message.wrappedValue != nil },
                set: { if !$0 { message.wrappedValue = nil } }
            ),
            dismissOnBackgroundTap: dismissOnBackgroundTap
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
