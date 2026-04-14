//
//  MyPageCoordinator.swift
//  jjanpot
//
//  Created by 임주희 on 4/14/26.
//

import SwiftUI

final class MyPageCoordinator: MyPageCoordinatorProtocol {
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func showSettings() {
        appCoordinator.push(.settings)
    }

    func showAlarmSettings() {
        appCoordinator.push(.alarmSettings)
    }

    func showChallengeHistory() {
        appCoordinator.push(.challengeHistory)
    }

    func showChallengeReport(id: Int) {
        appCoordinator.push(.challengeReport(id: id))
    }

    func openFullScreenWebView(url: String) {
        appCoordinator.fullScreen(url: url)
    }

    func close() {
        appCoordinator.pop()
    }
}
