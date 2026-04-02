//
//  MainHeader.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//

import SwiftUI

enum MainHeaderType {
    case normal
    case alarm
    case setting
}
struct MainHeader: View {
    let type: MainHeaderType
    let action: (()->Void)?
    init(type: MainHeaderType = .normal, action: (()->Void)? = nil) {
        self.type = type
        self.action = action
    }
    var body: some View {
        HStack {
            Image("TextLogo")
                .resizable()
                .frame(width: 122, height: 18.49)
            Spacer()

            
            switch type {
            case .normal: EmptyView()
            case .alarm:  EmptyView()
            case .setting: setting
            }
            
        }
        .padding([.vertical, .leading], 20)
    }
    
    private var setting: some View {
        Button {
            action?()
        } label: {
            Image("icon_setting")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.horizontal, 20)
        }

    }
}

#Preview {
    MainHeader()
}
