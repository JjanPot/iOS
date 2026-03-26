//
//  CurrentChallengeEntityMapper.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//

import Foundation

struct CurrentChallengeEntityMapper {
    func map(from dto: ChallengeResponseDto) throws -> CurrentChallengeEntity  {
        let status: CurrentChallengeEntity.ChallengeStatus
        switch dto.status {
            case .none:
            status = CurrentChallengeEntity.ChallengeStatus.none
        case .waiting:
            guard let waitingDto = dto.waiting else { throw NetworkError.invalidResponse }
            status = CurrentChallengeEntity
                .ChallengeStatus
                .waiting(entity:
                            ChallengeWaitingEntity(
                                challengeId: waitingDto.challengeId,
                                title: waitingDto.title,
                                goalAmount: waitingDto.goalAmount,
                                startDate: waitingDto.startDate.toDate(.iso8601, locale: .kr) ?? Date(),
                                endDate: waitingDto.endDate.toDate(.iso8601, locale: .kr) ?? Date(),
                                isLeader: waitingDto.isLeader,
                                inviteCode: waitingDto.inviteCode
            ))
            
        case .ongoing:
            guard let ongoingDto = dto.ongoing else { throw NetworkError.invalidResponse }
            status = CurrentChallengeEntity
                .ChallengeStatus
                .inProgress(entity:
                                ChallengeInProgressEntity(
                                    challengeId: ongoingDto.challengeId,
                                    title: ongoingDto.title,
                                    endDate: ongoingDto.endDate.toDate(.iso8601, locale: .kr) ?? Date(),
                                    weekNumber: ongoingDto.weekNumber,
                                    weekGoalAmount: ongoingDto.weekGoalAmount,
                                    teamWeekSavedAmount: ongoingDto.teamWeekSavedAmount,
                                    personalWeekSavedAmount: 250000, //TODO: 임시 수정하기
                                    achievementRate: ongoingDto.achievementRate
            ))
        }
        
        return CurrentChallengeEntity(status: status)
    }
}
