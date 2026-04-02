//
//  ChallengeOverviewViewDataMapper.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//


import Foundation
import SwiftUI

struct ChallengeOverviewViewDataMapper {
    func map(from entity: OverviewEntity) -> ChallengeOverviewViewData{

        let date = entity.startDate.toString(format: "M월d일", locale: .kr)
        let segments = segments(from: entity.members, totalSavedAmount: entity.totalSavedAmount)
        let members = members(from: entity.members)

        return ChallengeOverviewViewData(
            title: entity.title,
            description: "\(date)부터 현재까지 절약금액",
            totalSavedAmount: entity.totalSavedAmount,
            goalAmount: entity.goalAmount,
            segments: segments,
            members: members
        )
    }

    private func segments(from members: [OverviewEntity.Member], totalSavedAmount: Int) -> [SegmentedBarViewData] {

        members.enumerated().map { index, member in
            SegmentedBarViewData(
                ratio: Double(member.savedAmount / totalSavedAmount),
                color: ColorPalette.chartColors[index]
            )
        }
    }
    
    private func members(from members: [OverviewEntity.Member]) -> [MemberCardViewData] {
        members.enumerated().map { index, member in
            MemberCardViewData(
                userId: member.userId,
                nickname: member.isMe ? "나" : member.nickname,
                imageUrl: member.profileImageURL,
                color: ColorPalette.chartColors[index],
                amount: member.savedAmount
            )
        }
    }
}
