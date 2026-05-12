//
//  FeedEditView.swift
//  jjanpot
//
//  Created by 임주희 on 4/14/26.
//

import SwiftUI
import PhotosUI
import Photos
import Kingfisher


/// 인증 수정 뷰
struct FeedEditView: View {
    @StateObject var viewModel: FeedEditViewModel
    private let coordinator: ChallengeCoordinatorProtocol
    init(viewModel: FeedEditViewModel, coordinator: ChallengeCoordinatorProtocol) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    @State private var isShowingPicker = false
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isShowingPhotoPicker = false
    // 새로 선택한 로컬 이미지
    @State private var selectedImage: (data: Data, image: Image)? = nil
    @State private var showPermissionAlert = false
    
    
    @FocusState private var isPriceFocused: Bool
    @FocusState private var isMemoFocused: Bool
    
    
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 지출, 무지출 탭
                    SegmentedToggleView(selectedTab: $viewModel.selectedTab)
                    
                    
                    // 카테고리
                    CategorySelector(
                        selected: $viewModel.selectedCategory,
                        categories: viewModel.categoryViewData)
                    
                    // 금액
                    priceTextField
                    
                    // 메모
                    memoTextField
                    
                    // 사진 업로드
                    images
                    
                    
                }// ~VStack
                .padding(.horizontal, 20)
            } // ~ ScrollView
            .scrollDismissesKeyboard(.interactively)
            
            VStack(alignment: .center, spacing: 22) {
                
                Text("부적절하거나 불쾌한 콘텐츠는 제재될 수 있어요")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black500)
                
                // 수정하기 버튼
                MainButton(title: "수정하기",
                           isDisabled: viewModel.isSubmitButtonDisabled()) {
                    viewModel.submit(selectedImageData: selectedImage?.data)
                }
            }
            .padding(.horizontal, 20)
            
            
        }// ~VStack
        .navigationTitle("인증 기록 수정")
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .task {
            viewModel.getDetail()
        }
        
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") {
                    // 모든 포커스 해제
                    isPriceFocused = false
                    isMemoFocused = false
                }
                .foregroundStyle(.orange500)
            }
        }
        // 사진 선택
        .sheet(isPresented: $isShowingPicker) {
            VStack(spacing: 10) {
                        DatePicker(
                            "날짜를 선택하세요",
                            selection: $viewModel.selectedDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical) // 달력 형태로 표시
                        
                        Button("완료") {
                            isShowingPicker = false
                        }
                        
                    }
                    .presentationDetents([.large])
                }
        .photosPicker(isPresented: $isShowingPhotoPicker, selection: $selectedPhotoItem, matching: .images)
        .onChange(of: selectedPhotoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data){
                    viewModel.uploadedImageUrl = nil
                    selectedImage = (data, Image(uiImage: uiImage))
                    
                }
            }
        }
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
        // ~ 사진 선택
        .onChange(of: viewModel.isSuccess) { isSuccess in
            // 저장완료시 화면 나가기
            if isSuccess {
                coordinator.close()
            }
        }
    }
    
        // MARK: - views..
    
    // 금액
    private var priceTextField: some View {
        VStack(alignment: .leading, spacing: 10) {
            PostTitleView(title: viewModel.selectedTab == .expense ? "지출 금액" : "절약 금액", isNeccessary: true)
            HStack {
                if viewModel.selectedTab == .expense {
                    TextField("", text: $viewModel.price, prompt:
                                Text("오늘 쓴 금액을 기록해 주세요")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color.black200)
                    )
                    
                    .disabled(viewModel.selectedTab == .noExpense)
                    .keyboardType(.numberPad)
                    .focused($isPriceFocused)
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black700)
                    .onSubmit {
                        isPriceFocused = false
                    }
                    
                } else {
                    if let amount = viewModel.selectedCategory?.amount {
                        Text("\(amount)")
                            .font(.pretendard(.regular, size: 14))
                            .foregroundColor(Color.black700)
                            .padding(.vertical, 2)
                    }
                    Spacer()
                }

                Text("원")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black700)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .roundedBorder(color: .black100, radius: 12)
            .contentShape(Rectangle())
            .onTapGesture {
                if viewModel.selectedTab == .expense {
                        isPriceFocused = true
                    }
            }
        }
    }
    
    private var memoTextField: some View {
        VStack(alignment: .leading, spacing: 10) {
            PostTitleView(title: "메모", isNeccessary: false)

            ZStack(alignment: .topLeading) {
                // 1. 실제 입력창
                TextEditor(text: $viewModel.description)
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black700)
                    .focused($isMemoFocused)
                    .onSubmit {
                        isMemoFocused = false
                    }
                    .onChange(of: viewModel.description) { newValue in
                        if newValue.count > 30 {
                            viewModel.description = String(newValue.prefix(30))
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)


                // 2. 글자가 비어있을 때만 보여주는 Placeholder
                if viewModel.description.isEmpty {
                    Text("최대 30글자까지 입력해 주세요")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color.black200)
                        .allowsHitTesting(false)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                }
            }
            .frame(height: 104)
            .roundedBorder(color: .black100, radius: 12)
        }
    }
    
    
    // 사진 업로드
    private var images: some View {
        HStack(spacing: 8){
            // 사진 올리기 버튼
            Button {
                requestPhotoLibraryPermission()
            } label: {
                Color.black100
                    .frame(width: 84, height: 84)
                    .rounded(radius: 12)
                    .overlay(alignment: .center) {
                        Image("camera")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .foregroundStyle(.black300)
                    }
            }
            
            // 이미지
            Group {
                // 업로드된 사진
                if let contentImage = selectedImage?.image {
                    contentImage
                        .resizable()
                }
                // 서버에 이미 올라간 이미지
                if let imageUrl = viewModel.uploadedImageUrl {
                    KFImage(URL(string: imageUrl))
                        .placeholder {
                            Placeholder()
                                .frame(width: 85, height: 85)
                                .rounded(radius: 12)
                        }
                        .retry(maxCount: 3, interval: .seconds(2))
                        .onFailure { error in
                            Logger.error("Image load failed: \(error.localizedDescription)")
                        }
                        .fade(duration: 0.25)
                        .resizable()
                        
                }
            }
            .scaledToFill()
            .frame(width: 84, height: 84)
            .rounded(radius: 12)
            .clipShape(Rectangle())
            .overlay(alignment: .topTrailing) {
                Button {
                    // 사진 삭제
                    self.selectedImage = nil
                    viewModel.uploadedImageUrl = nil
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(Color.orange500)
                        .padding(4)
                }
            }
            
        }
    }
    
    // MARK: - Methods..
    
    // 사진권한 받아오기
    private func requestPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            isShowingPhotoPicker = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        isShowingPhotoPicker = true
                    }
                }
            }
        case .denied, .restricted:
            print("앨범 접근 권한이 거부되었습니다.")
            showPermissionAlert = true
        @unknown default:
            break
        }
    }
}

#Preview {
    let di = MockMainDIContainer()
    let coordinator = di.makeChallengeCoordinator(appCoordinator: di.makeAppCoordinator())
    return MockMainDIContainer().makeFeedEditView(
        challengeId: 1,
        feedEntity: FeedEntity(
            certificationId: 126,
            spendType: .expense,
            categoryName: "교통",
            userId: 4,
            userNickname: "주휘",
            memo: nil,
            savedAmount: 3000,
            imageURL: nil,
            createdAt: Date(),
            likeCount: 0,
            isLiked: false,
            isMe: true
        ),
        coordinator: coordinator)
}
