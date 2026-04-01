//
//  ChallengeDetailViewData.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


/*
    private let viewData = ChallengeDetailViewData(
        teamName: "배달을 아껴요",
        goals: "30만원 목표로 1주동안 함께 절약하기",
        category: "외식/배달",
        teamTargetAmount: "30만원",
        personTargetAmound: "2만원 이상",
        relationshipType: "친구",
        during: "26.07.15-26.07.15",
        memberCount: "5명",
        description: "배달을 아끼는 챌린지 방입니다. 모두 절약 파이팅"
    )
*/

struct ChallengeDetailViewData {
    let teamName: String
    let goals: String
    let category: String
    let teamTargetAmount: String
    let personTargetAmound: String
    let relationshipType: String
    let during: String
    let memberCount: String
    
    // 챌린지 설명
    let description: String
}


