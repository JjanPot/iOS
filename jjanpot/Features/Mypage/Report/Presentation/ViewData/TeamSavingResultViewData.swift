//
//  TeamSavingResultViewData.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import Foundation

// 팀 절약결과
struct TeamSavingResultViewData {
    let teamName: String
    
    // 절약결과
    let amount: Int
    // 결과 요약 ("목표 300,000원 달성🎉 총104%")
    let summaryMessage: String
    
    // 보상? "🎧 에어팟 + 치킨 1마리 🍗"
    let rewardMessage: String
    
}
