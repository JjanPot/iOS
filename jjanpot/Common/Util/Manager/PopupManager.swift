//
//  PopupManager.swift
//  jjanpot
//
//  Created by 임주희 on 3/27/26.
//

import SwiftUI
import Combine

/// 전역 팝업을 위한 매니저
final class PopupManager: ObservableObject {
    static let shared = PopupManager()

    @Published var showInviteCodePopup: Bool = false
    @Published var inviteCode: String? = nil

    private init() {}

    /// 초대 코드 입력 팝업 열기
    func showInviteCodeInput() {
        DispatchQueue.main.async { [weak self] in
            self?.inviteCode = nil
            self?.showInviteCodePopup = true
        }
    }

    /// 초대 코드 복사 팝업 열기
    func showInviteCodeCopy(code: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.inviteCode = code
            self?.showInviteCodePopup = true
        }
    }

    /// 팝업 닫기
    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            self?.showInviteCodePopup = false
        }
    }
}
