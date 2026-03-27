//
//  ToastManager.swift
//  jjanpot
//
//  Created by 임주희 on 3/27/26.
//


import SwiftUI
import Combine

// 전역 토스트를위한 매니저
final class ToastManager: ObservableObject {
    static let shared = ToastManager()

    @Published var message: String?

    private init() {}

    /// 토스트 메시지 표시
    func show(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.message = message
        }
    }

    /// 토스트 숨김
    func hide() {
        DispatchQueue.main.async { [weak self] in
            self?.message = nil
        }
    }
}
