//
//  ChallengeReportView.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//

import SwiftUI

struct ChallengeReportView: View {
    
    @StateObject var viewModel: ChallengeReportViewModel
    private let renderService = ImageRenderService()
    private let coordinator: MainCoordinator
    @State var showPermissionAlert = false
    @State var showShareSheet = false
    
    init(viewModel: ChallengeReportViewModel, coordinator: MainCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
   
    
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
                            // 앨범 접근 권한 확인
                            PhotoAuthManager.checkPhotoLibraryPermission { isGranted in
                                    if isGranted { // 권한이 있으므로 저장 로직 실행
                                        downloadImage()
                                    } else { // 권한이 없으므로 설정 창으로 유도하는 알럿 띄우기
                                        showPermissionAlert = true
                                    }
                                }
                            
                        } label: {
                            Image("icon_download")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // 결과화면
                    report
                    
                    // 절약 현황
                    if let summaryViewData = viewModel.summaryViewData {
                        ChallengeSummaryView(viewData: summaryViewData)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 29)
                    }
                    
                    
                    // 팀 정보
                    if let basicInfo = viewModel.detailViewData {
                        ChallengeBasicInfoView(viewData: basicInfo)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                    }
                    
                    VStack(spacing: 8) {
                        MainButton(title: (showShareSheet == false ? "친구에게 자랑하기" : "이미지 생성중.."),
                                   isDisabled: showShareSheet) {
                            viewModel.isLoading = true
                            showShareSheet = true
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    Spacer()
                }
            }
        } // ~Zstack
        .task {
            viewModel.loadReport()
            viewModel.loadSummary()
        }
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .alert("사진 접근 권한 필요", isPresented: $showPermissionAlert) {
            Button("확인", role: .cancel) { }
            Button("설정으로 이동") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("앨범의 사진을 불러오려면 설정에서 사진 접근 권한을 허용해주세요.")
        }
        .sheet(isPresented: $showShareSheet, onDismiss: {
            viewModel.isLoading = false
        }) {
            if let uiImage = renderService.exportToImage(view: downLoadView) {
                ShareSheet(items: [uiImage], title: "짠팟 ㅣ 절약 결과", showImagePreview: true)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
   
    
    private var report: some View {
        VStack(spacing: .zero){
            if let viewData = viewModel.reportViewData {
                
                reportHeader
                    .padding(.bottom, 32)
                
                // 팀 결과
                TeamSavingResultView(
                    viewData: viewData.teamSavingResult)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                
                // 개인 절약
                personalSaving
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
        }
    }
    
    private var reportHeader: some View {
        Group{
            if let viewData = viewModel.reportViewData {
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
            }
        }
    }
    
    
    // 개인 절약 금액
    private var personalSaving: some View {
        Group {
            if let viewData = viewModel.reportViewData {
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
            }
        }
    }
    
    private var downLoadView: some View {
        ZStack {
            LinearGradient(
                  colors: [.white, .orange100],
                  startPoint: .top,
                  endPoint: .bottom
              )
            
            report
        }
    }
    
    
    private func downloadImage() {
        viewModel.isLoading = true
        if let uiImage = renderService.exportToImage(view: downLoadView) {
            // 앨범에 저장
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            viewModel.toastMessage = "저장되었습니다."
            viewModel.isLoading = false
        }
    }
}


@MainActor
struct ImageRenderService {
    func exportToImage(view: some View) -> UIImage? {
        // ImageRenderer 인스턴스 생성
        let renderer = ImageRenderer(content: view)
        // 해상도 설정 (디스플레이 배율에 맞춤)
        renderer.scale = UIScreen.main.scale
        // UIImage로 변환
        return renderer.uiImage
    }
}


#Preview {
    let di = MockMainDIContainer()
    di.makeChallengeReportView(challengeId: 6,coordinator: di.makeMainCoordinator())
}

