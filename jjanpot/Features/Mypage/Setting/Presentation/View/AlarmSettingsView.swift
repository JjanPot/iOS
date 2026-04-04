//
//  AlarmSettingsView.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import SwiftUI

struct AlarmSettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    
    @State var isFirstOfdailyEnabled = true
    @State var isFirstOfWeeklyEnabled = true
    @State var isFirstOfMarketingConsent = true
    
    init(viewModel: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 60){
            AlarmSettingMenuSection("리마인드 알림") {
                AlarmSettingMenuButton(title: "1일 1회 미인증 알림",
                                       subTitle: "매일 저녁 6시에 알림을 받을 수 있어요.",
                                       toggleValue: $viewModel.dailyEnabled)
                .onChange(of: viewModel.dailyEnabled) { _ in
                    if isFirstOfdailyEnabled {
                        isFirstOfdailyEnabled = false
                        return
                    }
                    viewModel.setNotificationSettings()
                }
                
                AlarmSettingMenuButton(title: "주간 미인증 알림",
                                       subTitle: "주 3회 저녁8시에 알림을 받을 수 있어요.",
                                       toggleValue: $viewModel.weeklyEnabled)
                .onChange(of: viewModel.weeklyEnabled) { _ in
                    if isFirstOfWeeklyEnabled {
                        isFirstOfWeeklyEnabled = false
                        return
                    }
                    viewModel.setNotificationSettings()
                }
            }
            
            AlarmSettingMenuSection("혜택·이벤트 및 기타 푸시 알림") {
                AlarmSettingMenuButton(title: "마케팅 수신 동의",
                                       subTitle: "[짠팟] 마케팅 정보 수신 동의",
                                       toggleValue: $viewModel.marketingConsent)
                .onChange(of: viewModel.marketingConsent) { _ in
                    if isFirstOfMarketingConsent {
                        isFirstOfMarketingConsent = false
                        return
                    }
                    viewModel.setNotificationSettings()
                }
            }
            
            Spacer()
        }
        .task {
            viewModel.getNotificationSettings()
        }
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .padding(20)
    }
}

#Preview {
    MockMainDIContainer().makeAlarmSettingsView()
}
