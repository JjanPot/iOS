//
//  ChallengeReportView.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//

import SwiftUI

struct ChallengeReportViewData {
    enum Result {
        case success
        case failed
        
        var title: String {
            switch self {
            case .success: return "목표 달성!"
            case .failed: return "목표 실패"
            }
        }
        var image: String {
            switch self {
            case .success: return "success"
            case .failed: return "failure"
            }
        }
    }
    
    let result: Result
    let message: String
    let teamName: String
    
    // 절약결과
    let amount: Int
    // 결과 요약 ("목표 300,000원 달성🎉 총104%")
    let summaryMessage: String
    
    // 보상? "🎧 에어팟 + 치킨 1마리 🍗"
    let rewardMessage: String
    
    // 개인절약금액
    let personalSavingAmount: Int
    
    // 절약현황
    let summaryViewData: ChallengeSummaryViewData
    
    // 챌린지 기본 정보
    let basicInfo: ChallengeBasicInfoViewData
    
    
}

struct ChallengeReportView: View {
    private let viewData = ChallengeReportViewData(
        result: .failed,
        message: "완벽한 팀워크, 완벽한 절약!\n함께라서 더 빛나는 결과예요.",
        teamName: "배달을 아껴요",
        amount: 297_000,
        summaryMessage: "목표 300,000원 달성🎉 총104%",
        rewardMessage: "🎧 에어팟 + 치킨 1마리 🍗",
        personalSavingAmount: 25_000,
        summaryViewData: ChallengeSummaryViewData(team: ChallengeSummaryViewData.SavingsSummaryViewData(
            certificationCount: "3.0",
            participationRate: "100",
            consecutiveDays: "1"),
                                 personal: ChallengeSummaryViewData.SavingsSummaryViewData(certificationCount: "0", participationRate: "33", consecutiveDays: "0")),
        basicInfo: ChallengeBasicInfoViewData(
            teamName: "배달을 아껴요",
            goals: "30만원 목표로 1주 함께 절약하기",
            category: "외식/배달",
            teamTargetAmount: "30만원",
            personTargetAmound: "2만원 이상",
            relationshipType: "친구",
            during: "26.07.15 - 16.07.21(1주)",
            memberCount: "5명"
        )
    )
    
//    @StateObject var viewModel: ChallengeReportViewModel
//    private let coordinator: MainCoordinator
//    
//    init(viewModel: ChallengeReportViewModel, coordinator: MainCoordinator) {
//        self._viewModel = StateObject(wrappedValue: viewModel)
//        self.coordinator = coordinator
//    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                  colors: [.white, .orange100],
                  startPoint: .top,
                  endPoint: .bottom
              )
              .ignoresSafeArea()
            
            ScrollView {
                VStack (alignment: .center, spacing: .zero){
                    
                    // download
                    HStack {
                        Spacer()
                        Button {
                            
                        } label: {
                            Image("icon_download")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    Group{
                        
                        VStack (alignment: .center, spacing: .zero){
                            Image(viewData.result.image)
                                .resizable()
                                .frame(width: 131, height: 92)
                                .padding(.vertical, 15)
                            
                            Text(viewData.result.title)
                                .font(.pretendard(.semiBold, size: 30))
                                .foregroundStyle(Color.blue500)
                                .padding(.bottom, 8)
                            
                            Text(viewData.message)
                                .font(.pretendard(.semiBold, size: 16))
                                .foregroundStyle(Color.black700)
                        }
                        .padding(.bottom, 32)
                        
                        // 팀 결과
                        VStack {
                            Text("\(viewData.teamName) 팀 절약 결과")
                                .font(.pretendard(.semiBold, size: 16))
                                .foregroundStyle(.orange900)
                            
                            HStack(alignment: .bottom, spacing: 8) {
                                Text("\(viewData.amount)")
                                    .font(.pretendard(.bold, size: 56))
                                    .foregroundStyle(.red500)
                                Text("원")
                                    .padding(.bottom, 10)
                                    .font(.pretendard(.semiBold, size: 16))
                                    .foregroundStyle(Color.orange900)
                            }
                            Text(viewData.summaryMessage)
                                .font(.pretendard(.semiBold, size: 16))
                                .foregroundStyle(.red500)
                            
                            VStack(alignment: .center, spacing: 10){
                                Text("이 금액으로 살 수 있어요")
                                    .font(.pretendard(.medium,size: 20))
                                    .foregroundStyle(Color.black700)
                                
                                Text(viewData.rewardMessage)
                                    .font(.pretendard(.semiBold, size: 24))
                                    .foregroundStyle(Color.orange500)
                            }
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color.white)
                            .rounded(radius: 12)
                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                colors: [.white, .orange200],
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                        .rounded(radius: 20)
                        .roundedBorder(color: .orange400, radius: 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                        
                        
                        // 개인 절약
                        HStack(spacing: 8) {
                            Image("flag")
                                .resizable()
                                .frame(width: 13.39, height: 16)
                            
                            Text("개인 절약")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundStyle(.black500)
                            
                            Spacer()
                            Text("\(viewData.personalSavingAmount)원")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundStyle(.black900)
                        }
                        .padding(20)
                        .background(Color.white)
                        .roundedBorder(color: .orange300, radius: 12)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                    
                    
                    // 절약 현황
                    ChallengeSummaryView(viewData: viewData.summaryViewData)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 29)
                    
                    
                    // 팀 정보
                    ChallengeBasicInfoView(viewData: viewData.basicInfo)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    
                    VStack(spacing: 8) {
                        MainButton(title: "친구에게 자랑하기") {
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    
                    Spacer()
                }
            }
        }
    }
    
}

#Preview {
    ChallengeReportView()
}


protocol ChallengeReportRepositoryProtocol {
    
}

struct ChallengeReportRepository: ChallengeReportRepositoryProtocol {
    private let challengeApiClient: ChallengeApiClientProtocol

    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.challengeApiClient = challengeApiClient
    }

    /*
    func agree<#name#>(marketingConsentAgreed: Bool ) async throws {
        let result = await challengeApiClient.agreement(marketingConsentAgreed: marketingConsentAgreed)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }*/
}



protocol ChallengeReportUseCaseProtocol {
    
}
struct ChallengeReportUseCase: ChallengeReportUseCaseProtocol {
    private let repository: ChallengeReportRepositoryProtocol
    init(repository: ChallengeReportRepositoryProtocol) {
        self.repository = repository
    }
}



import SwiftUI
import Combine
final class ChallengeReportViewModel: ObservableObject {
 @Published var isLoading = false
    @Published var toastMessage: String?

     private let useCase: ChallengeReportUseCaseProtocol
    init(useCase: ChallengeReportUseCaseProtocol) {
        self.useCase = useCase
    }
}





// MARK: -

//private func makeChallengeReportRepository() -> ChallengeReportRepositoryProtocol {
//        return ChallengeReportRepository(challengeApiClient: challengeApiClient)
//    }
//    private func makeChallengeReportUseCase() -> ChallengeReportUseCaseProtocol {
//        let repo = makeChallengeReportRepository()
//        return ChallengeReportUseCase(repository: repo)
//    }
//    private func makeChallengeReportViewModel() -> ChallengeReportViewModel {
//        let usecase = makeChallengeReportUseCase()
//        return <#name#>ViewModel(useCase: usecase)
//    }
//
//    func makeChallengeReportView(coordinator: MainCoordinator) -> ChallengeReportView {
//        let vm = makeChallengeReportViewModel()
//        return ChallengeReportView(viewModel: vm, coordinator: coordinator)
//    }




