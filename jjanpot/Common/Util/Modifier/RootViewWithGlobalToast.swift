//
//  RootViewWithGlobalToast.swift
//  jjanpot
//
//  Created by 임주희 on 3/27/26.
//


import SwiftUI

// MARK: - 전역 토스트를 위한 Root View
struct RootViewWithGlobalToast<Content: View>: View {
    @StateObject private var toastManager = ToastManager.shared
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .toast(message: $toastManager.message, bottomPadding: 90)
    }
}
