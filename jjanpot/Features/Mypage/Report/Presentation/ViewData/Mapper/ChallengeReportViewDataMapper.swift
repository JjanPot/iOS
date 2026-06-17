//
//  ChallengeReportViewDataMapper.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//


struct ChallengeReportViewDataMapper {
    func map(from reportEntity: ChallengeReportEntity,
             detailEntity: ChallengeDetailEntity) -> ChallengeReportViewData{
        let result = reportEntity.isTeamSuccess ? ChallengeReportViewData.Result.success : ChallengeReportViewData.Result.failed
        
        
        let reportMessage = reportMessage(
            isTeamSuccess: reportEntity.isTeamSuccess,
            personalGoalAmount: detailEntity.minPersonalGoalAmount,
            personalSavedAmount: reportEntity.personalSavedAmount
        )
        
        let summaryMessage = reportEntity.isTeamSuccess ? "목표 \(reportEntity.goalAmount)원 달성🎉 총\(reportEntity.achievementRate)%" : "목표 \(reportEntity.goalAmount)원 실패⚠️  총\(reportEntity.achievementRate)%"
        
        // 팀 절약 결과
        let teamSavingResult = TeamSavingResultViewData(
            teamName: detailEntity.title,
            amount: reportEntity.totalSavedAmount,
            summaryMessage: summaryMessage,
            rewardMessage: "🎧 에어팟 + 치킨 1마리 🍗"
        )
        
        
        return ChallengeReportViewData(
            result: result,
            message: reportMessage,
            // 팀 절약 결과
            teamSavingResult: teamSavingResult,
            // 개인절약금액
            personalSavingAmount: reportEntity.personalSavedAmount
        )
    }
    
    // "완벽한 팀워크, 완벽한 절약!\n함께라서 더 빛나는 결과예요."
    
    private func reportMessage(isTeamSuccess: Bool,
                               personalGoalAmount: Int,
                               personalSavedAmount: Int) -> String {
        
        // 개인 최소금액 달성
        let isPersonalSuccess: Bool = (personalSavedAmount >= personalGoalAmount)
        
        var message: String
        switch (isTeamSuccess, isPersonalSuccess){
        case (true, true): // 팀성공 && 개인성공
            message = [
                "이번 목표도 무사히 달성했어요.\n역시 우리는 최고의 팀이에요!",
                "완벽한 팀워크, 완벽한 절약!\n함께라서 더 빛나는 결과예요.",
                "우리 팀, 아무도 포기하지 않았어요!\n이 챌린지, 모두가 주인공이에요."
            ].randomElement()!
            
            
        case (true, false): //팀 성공 & 개인 실패
            message = [
                "내 목표는 아쉽게 놓쳤지만,\n다음에는 성공할 수 있을 거예요!",
                "팀은 해냈어요, 다음엔 나도!\n다음엔 내 목표도 달성해봐요!"
            ].randomElement()!
                       
            
        case (false, true): // 팀 실패 & 개인 성공
            message = [
                "나의 값진 성공,\n다음엔 팀과 함께 나눠요!",
                "혼자서도 지켰어요, 대단해요!\n팀 전체가 함께하는 날이 곧 올 거예요"
            ].randomElement()!
            
            
            
        case (false, false): // 팀 실패 & 개인 실패
            message = [
                "아쉽게 놓쳤지만,\n우리의 도전은 멈추지 않아요!",
                "이번엔 아쉬웠지만, 괜찮아요.\n팀과 함께라면 다음엔 분명 달라질 거예요."
            ].randomElement()!
        }
        
        return message
    }
}
