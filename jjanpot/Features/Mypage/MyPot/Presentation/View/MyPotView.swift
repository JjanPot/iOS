//
//  MyPotView.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//

import SwiftUI
import Kingfisher

struct MyPotView: View {
    
    @StateObject var viewModel: MyPotViewModel
    private let coordinator: MainCoordinator
    
    init(viewModel: MyPotViewModel, coordinator: MainCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                MainHeader(type: .setting) {
                    coordinator.push(.settings)
                }
                
                Group {
                    profill
                    
                    // 챌린지 참여 현황
                    if let viewData = viewModel.myStatsViewData {
                        Button {
                            coordinator.push(.challengeHistory)
                        } label: {
                            HStack {
                                MyChallengeStatsItemView(.totalChallenge, content: viewData.totalCount)
                                Spacer()
                                MyChallengeStatsItemView(.success, content: viewData.successCount)
                                Spacer()
                                MyChallengeStatsItemView(.failed, content: viewData.failCount)
                                Spacer()
                                MyChallengeStatsItemView(.successRate, content: viewData.successRate)
                                
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .roundedBorder(color: .orange400, radius: 12)

                        }
                    }
                    
                    // 문의하기
                    Button {
                        coordinator.fullScreenWebView(url: AppConstants.URLs.useGuide)
                    } label: {
                        contactView
                    }
                    
                    
                        #if DEBUG
                        
                        Button("로그 공유 (\(Logger.getLogCount())개)"){
                            shareLog()
                        }
                       
                        #endif
                                            
                    
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        } //ScrollView
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .task {
            viewModel.loadUserInfo()
            viewModel.getMyChallengeStats()
        }
    }
    
    private var profill: some View {
        HStack(alignment: .center, spacing: 14) {
            Group {
                if let imageUrl = viewModel.profileViewData?.imageUrl {
                    KFImage(URL(string: imageUrl))
                        .placeholder {
                            placeholder
                        }
                        .retry(maxCount: 3, interval: .seconds(2))
                        .onFailure { error in
                            Logger.error("Image load failed: \(error.localizedDescription)")
                        }
                        .fade(duration: 0.25)
                        .resizable()
                        .scaledToFill()
                } else {
                    placeholder
                }
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            
            
            Text(viewModel.profileViewData?.nickname ?? "")
                .font(.pretendard(.semiBold, size: 16))
                .foregroundStyle(Color.black900)
            
        }
    }
    private var placeholder: some View {
        Color.black100
            .overlay(alignment: .center) {
                Image("person")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
    }
    
    private var contactView: some View {
        HStack(alignment: .center, spacing: .zero ) {
            Image("file")
                .resizable()
                .frame(width: 24, height: 24)
            VStack (alignment: .leading, spacing: .zero ){
                Text("문의하기/의견 남기기")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundStyle(Color.black900)
                
                Text("여러분의 작은 의견이 서비스를 더 좋게 만들어요")
                    .font(.pretendard(.regular, size: 12))
                    .foregroundStyle(Color.black500)
            }
            
            Spacer()
            Image(systemName: "chevron.right")
                .renderingMode(.template)
                .foregroundStyle(Color.black50)
            
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color.orange50)
        .rounded(radius: 12)
    }
    
    
    
    private func shareLog() {
        print(">>> shareLog 호출됨")
        print(">>> 현재 로그 개수: \(Logger.getLogCount())")

        // 로그 파일 생성
        guard let fileURL = Logger.exportLogsToFile() else {
            print(">>> 로그 파일 생성 실패")
            ToastManager.shared.show("공유할 로그가 없습니다")
            return
        }

        print(">>> 로그 파일 생성 성공: \(fileURL.path)")

        // UIKit 방식으로 직접 공유 시트 띄우기
        let activityVC = UIActivityViewController(
            activityItems: [fileURL],
            applicationActivities: nil
        )

        // iPad 지원
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {

            // 현재 presented 된 VC 찾기
            var topVC = rootVC
            while let presentedVC = topVC.presentedViewController {
                topVC = presentedVC
            }

            // iPad에서 popover 설정
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = topVC.view
                popover.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }

            topVC.present(activityVC, animated: true)
            print(">>> 공유 시트 표시 완료")
        }

        //Logger.info("로그 파일 공유 준비 완료: \(fileURL.lastPathComponent)")
    }
}

#Preview {
    let di = MockMainDIContainer()
    di.makeMyPotView(coordinator: di.makeMainCoordinator())
}



