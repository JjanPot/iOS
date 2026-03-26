//
//  ChallengeCardViewDataMapper.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation

struct ChallengeCardViewDataMapper {
    func map(from entity: CurrentChallengeEntity) -> ChallengeCardStatus {
        switch entity.status {
        case .none:
            return ChallengeCardStatus.none
        case .waiting(let entity):
            let viewData = ChallengeWaitingViewData(
                teamName: entity.title,
                targetSavingsAmount: (entity.goalAmount/10000), //만원단위로 자름.
                period: period(start: entity.startDate, end: entity.endDate),
                inviteCode: entity.inviteCode
            )
            return ChallengeCardStatus.waiting(viewData: viewData)
            
            
        case .inProgress(let entity):
            let viewData = ChallengeInProgressViewData(
                teamName: entity.title,
                dday: dDayString(to: entity.endDate),
                teamSavingsAmount: formatPrice(entity.teamWeekSavedAmount),
                personalSavingsAmount: formatPrice(entity.personalWeekSavedAmount)
            )
            return ChallengeCardStatus.inProgress(viewData: viewData)
        }
    }
    
    // 시작일 - 종료일 (1주), ex: "26.07.15 - 26.07.21 (1주)"
    func period(start :Date, end: Date) -> String {
        "\(start.toString(.simpleDateOnly)) - \(end.toString(.simpleDateOnly)) (1주)"
    }
    
    func dDayString(to targetDate: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: targetDate)
        
        let diff = calendar.dateComponents([.day], from: today, to: target).day ?? 0
        
        if diff == 0 {
            return "D-Day"
        } else if diff > 0 {
            return "D-\(diff)"
        } else {
            return "D+\(-diff)"
        }
    }
    
    func formatPrice(_ value: Int) -> String {
        let converted = value / 10
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return (formatter.string(from: NSNumber(value: converted)) ?? "\(converted)") + "원"
    }
}
