//
//  MyPageCoordinatorProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/14/26.
//

import Foundation

/// MyPage Feature의 기능 인터페이스
protocol MyPageCoordinatorProtocol: AnyObject {
    func showSettings()
    func showAlarmSettings()
    func showChallengeHistory()
    func showChallengeReport(id: Int)

    func openFullScreenWebView(url: String)

    func close()
}
