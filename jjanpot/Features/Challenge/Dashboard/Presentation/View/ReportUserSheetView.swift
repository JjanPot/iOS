//
//  ReportUserSheetView.swift
//  jjanpot
//
//  Created by 임주희 on 4/11/26.
//

import SwiftUI

struct ReportUserSheetView: View {
    let onReportUser: (() -> Void)?
    let onBlockUser: (() -> Void)?
    let onCloseAction: (() -> Void)?
    
    
    var body: some View {
        VStack (alignment: .leading, spacing: 14){
        
            VStack (alignment: .leading, spacing: .zero){
                Button {
                    onReportUser?()
                } label: {
                    HStack(alignment: .center, spacing: 8) {
                        Image("icon_alert_triangle")
                        Text("사용자 신고하기")
                            .font(.pretendard(.medium, size: 16))
                            .foregroundStyle(Color.black600)
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .padding(.vertical, 10)
                }
                
                Divider()
                    .padding(.horizontal, 10)
                
                Button {
                    onBlockUser?()
                } label: {
                    HStack(alignment: .center, spacing: 8) {
                        
                        Image("icon_frown")
                        Text("사용자 차단하기")
                            .foregroundStyle(Color.black600)
                            .font(.pretendard(.medium, size: 16))
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .padding(.vertical, 10)
                }
            }
            .padding(.vertical, 8)
            .background(Color.black50)
            .rounded(radius: 12)
            
            Spacer()
            
            MainButton(title: "닫기") {
                onCloseAction?()
            }
        }
        .padding(20)
        .padding(.top, 40)
    }
}

#Preview {
    ZStack {
        Color.black200
        ReportUserSheetView(onReportUser: {}, onBlockUser: {}, onCloseAction: {})
    }
}
