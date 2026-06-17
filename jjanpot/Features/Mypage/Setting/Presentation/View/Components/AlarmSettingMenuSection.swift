//
//  AlarmSettingMenuSection.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


import SwiftUI

struct AlarmSettingMenuSection<Content: View>: View {
    let title: String
    let content: () -> Content
    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            Text(title)
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.black400)
            VStack(alignment: .leading, spacing: 30) {
                content()
            }
        }
    }
}

struct AlarmSettingMenuButton: View {
    let title: String
    let subTitle: String?
    @Binding var toggleValue: Bool
    init(title: String, subTitle: String?, toggleValue: Binding<Bool>) {
        self.title = title
        self.subTitle = subTitle
        self._toggleValue = toggleValue
    }
    
    var body: some View {
        HStack(alignment: .center){
            VStack (alignment: .leading, spacing: 2){
                Text(title)
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.black600)
                
                if let subTitle {
                    Text(subTitle)
                        .font(.pretendard(.regular, size: 12))
                        .foregroundStyle(.black400)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: false)
            
            Spacer()
            
            Toggle(isOn: $toggleValue) {}
                .tint(Color.orange500)
                .onChange(of: toggleValue) { _ in }
                .frame(maxWidth: 80)
        }
    }
}
