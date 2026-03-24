//
//  TermsView.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import Foundation
import SwiftUI

struct TermsView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("서비스 이용을 위해\n이용약관 동의가 필요해요")
                .multilineTextAlignment(.leading)
                .font(.pretendard(.semiBold), size: 24)
                .padding(20)
            
            TermsCheckBoxGroup()
                .padding(20)
            
            Spacer()
        }
        
    }
    
}


struct TermsCheckBoxGroup: View {
    @State private var allChecked = false
    @State private var items = [false, false, false, false]
    
    var body: some View {
        
        CheckBoxGroup(
            allChecked: $allChecked,
            items: $items,
            allLabel: "약관에 모두 동의합니다.",
            itemLabels: [
                "만 14세 이상입니다. (필수)",
                "서비스 이용약관 동의 (필수)",
                "개인정보 수집 및 이용 동의 (필수)",
                "마케팅 정보 수신 동의 (선택)"
            ],
            itemButtonTexts: [nil, "보기", "보기", "보기"],
            itemButtonActions: [
                nil,
                { print("서비스 이용약관 동의 보기") },
                { print("개인정보 수집 및 이용 동의 보기") },
                { print("마케팅 정보 수신 동의 보기") }
            ]
        )
        
    }
}


#Preview {
    TermsView()
}
