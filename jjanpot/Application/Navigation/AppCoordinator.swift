//
//  AppCoordinator.swift
//  jjanpot
//
//  Created by 임주희 on 4/14/26.
//

import Combine
import Foundation
import SwiftUI

/*
구조 정리:
App Level: RootCoordinator + AppCoordinator 생성
    ↓
MainNavigationStack (AppCoordinator 주입받음)
    ↓
ChallengeCoordinator (AppCoordinator 래핑)
*/

@MainActor
final class AppCoordinator: ObservableObject {
    private let container: MainDIContainerProtocol
    @Published var path = NavigationPath()
    
    @Published var activePopup: MainPopupDestination?
    @Published var activeSheet: MainSheetDestination?
    @Published var webViewUrl: String?
    
    init(container: MainDIContainerProtocol) {
        self.container = container
    }
    
    // MARK: - Navigation Methods
    
    /// 특정 화면으로 이동
    func push(_ destination: MainDestination) {
        path.append(destination)
    }
    
    /// 이전 화면으로 돌아가기
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// 특정 개수만큼 뒤로 가기
    func pop(count: Int) {
        guard path.count >= count else { return }
        path.removeLast(count)
    }
    
    /// 네비게이션 스택 초기화 (루트로 이동)
    func popToRoot() {
        path = NavigationPath()
    }
    
    // MARK: -
    
    func showPopup(_ destination: MainPopupDestination){
        activePopup = destination
    }
    
    func showModal(title: String, content: String, confirmButtonTitle: String = "확인", onConfirm: @escaping () -> Void) {
        activePopup = .modal(modal: AnyView(
            Modal(title: title, content: content).buttons {
                ModalButton(title: "닫기", colorType: .secondary) {
                    self.closePopup()
                }
                ModalButton(title: confirmButtonTitle, size: .large) {
                    onConfirm()
                }
            }
        ))

    }
    
    func closePopup(){
         activePopup = nil
    }
    
    func sheet(_ destination: MainSheetDestination) {
        activeSheet = destination
    }
    func closeSheet() {
        activeSheet = nil
    }
    
    
    func fullScreen(url: String) {
        webViewUrl = url
    }
    
    func closeFullScreen(){
        webViewUrl = nil
    }
    

    /// 모달 팝업 표시
//    func showReportModal(title: String, content: String, confirmButtonTitle: String = "확인", onConfirm: @escaping () -> Void) {
//        activePopup = .modal(modal: AnyView(
//            Modal(title: title, content: content).buttons {
//                ModalButton(title: "닫기", colorType: .secondary) {
//                    self.activePopup = nil
//                }
//                ModalButton(title: confirmButtonTitle, size: .large) {
//                    onConfirm()
//                }
//            }
//        ))
//    }
   
}

