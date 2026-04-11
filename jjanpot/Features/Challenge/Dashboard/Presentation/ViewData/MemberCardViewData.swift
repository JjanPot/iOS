//
//  MemberCardViewData.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//


import Foundation
import SwiftUI

struct MemberCardViewData {
    let userId: Int
    let nickname: String
    let imageUrl: String?
    let color: Color
    let amount: Int
    
    let isMe: Bool
    let isLeader: Bool
    let isBlocked: Bool
}
