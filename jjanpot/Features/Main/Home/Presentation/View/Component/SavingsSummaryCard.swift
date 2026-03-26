//
//  SavingsSummaryCard.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//

import SwiftUI


enum SavingsSummaryCardType {
    case averageProof        // 인증평균
    case participationRate   // 참여율
    case consecutiveActivity // 연속활동
    case proofCount          // 인증횟수
    
    var icon: icon {
        switch self {
        case .averageProof:
                 return .graph
        case .participationRate:
            return .percent
        case .consecutiveActivity:
            return .fire
        case .proofCount:
            return .checkbox
        }
    }
    
    var name: String {
        switch self {
        case .averageProof:
            return "인증평균"
        case .participationRate:
            return "참여율"
        case .consecutiveActivity:
            return "연속활동"
        case .proofCount:
            return "인증횟수"
        }
    }
    
    enum icon: String{
        case fire = "icon_fire"
        case percent = "icon_percent"
        case graph = "icon_graph"
        case checkbox = "icon_checkbox"
    }
    
    var unit: String {
        switch self {
        case .averageProof:
            return "회"
        case .participationRate:
            return "%"
        case .consecutiveActivity:
            return "일"
        case .proofCount:
            return "회"
        }
    }
}

struct SavingsSummaryCardTitleBadge: View {
    let type: SavingsSummaryCardType
    var body: some View {
        
        HStack(spacing: 3) {
            Image(type.icon.rawValue)
                .resizable()
                .frame(width: 18, height: 18)
            
            Text(type.name)
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(Color.black900)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color.orange100)
        .clipShape(Capsule())
    }
}


struct SavingsSummaryCard: View {
    let type: SavingsSummaryCardType
    let value: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            SavingsSummaryCardTitleBadge(type: type)
            
            HStack(alignment: .bottom, spacing: 4){
                Text(value)
                    .font(.pretendard(.semiBold, size: 30))
                    .foregroundStyle(.black900)
                
                Text(type.unit)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(.black900)
                    .padding(.bottom, 4)
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 13.5)
        .roundedBorder(color: .orange300, radius: 12)
    }
}

#Preview {
    SavingsSummaryCard(type: .proofCount, value: "100")
}
