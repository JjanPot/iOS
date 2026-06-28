//
//  FeedPostView.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI
import PhotosUI
import Photos

enum FeedPostTab: String {
    case expense = "SPEND"  // 지출
    case noExpense = "NO_SPEND" // 무지출
}


struct FeedPostView: View {
    @StateObject var viewModel: FeedPostViewModel
    private let coordinator: ChallengeCoordinatorProtocol

    init(viewModel: FeedPostViewModel, coordinator: ChallengeCoordinatorProtocol) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    @State private var selectedTab: FeedPostTab = .expense
    
    @State private var price: String = ""
    @State private var description: String = ""
    
    @FocusState private var isPriceFocused: Bool
    @FocusState private var isMemoFocused: Bool
    
    @State private var isShowingPicker = false
    @State private var selectedDate: Date = Date()
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    // 카메라&앨범미리보기 sheet열기
    @State private var isShowingPhotoSheet = false
    // 앨범열기
    @State private var isShowingPhotoPicker = false
    // 카메라 열기
    @State private var isShowingCamera = false
    
    
    @State private var selectedImage: (data: Data, image: Image)? = nil
    // 앨범 접근 권한 재요청
    @State private var showPermissionAlert = false
        
    var body: some View {
        
        VStack(alignment: .center, spacing: .zero) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 지출, 무지출 탭
                    SegmentedToggleView(selectedTab: $selectedTab)
                    
                    // 카테고리
                    CategorySelector(
                        selected: $viewModel.selectedCategory,
                        categories: viewModel.categoryViewData)
                    
                    // 금액 (지출금액 / 절약금액)
                    priceTextField
                    
                    // 절약 금액 (계산된 금액)
                    if let amount = viewModel.selectedCategory?.amount,
                       let priceInt = Int(price), selectedTab == .expense {
                        
                        Text("절약금액: \(amount - priceInt)")
                    }
                    
                    
                    // 메모
                    memoTextField
                    
                    // 사진 업로드
                    images
                    
                    Spacer()
                        .frame(height: 50)
                    
                    VStack(alignment: .center, spacing: 22) {
                        Text("부적절하거나 불쾌한 콘텐츠는 제재될 수 있어요")
                            .font(.pretendard(.regular, size: 14))
                            .foregroundColor(Color.black500)
                        
                        
                        // 등록하기 버튼
                        MainButton(title: "등록하기", isDisabled: isSubmitButtonDisabled()) {
                            viewModel.submit(
                                expenseType: selectedTab,
                                category: viewModel.selectedCategory,
                                price: price,
                                description: description,
                                date: selectedDate,
                                selectedImageData: selectedImage?.data)
                        }
                    }
                    
                   
                } // ~VStack
                .padding(.horizontal, 20)
            } // ~ ScrollView
            .scrollDismissesKeyboard(.interactively)
            
            
        }// ~VStack
        .navigationTitle("인증하기")
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
        // 날짜 선택
        .sheet(isPresented: $isShowingPicker) {
            VStack(spacing: 10) {
                        DatePicker(
                            "날짜를 선택하세요",
                            selection: $selectedDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical) // 달력 형태로 표시
                        
                        Button("완료") {
                            isShowingPicker = false
                        }
                        
                    }
                    .presentationDetents([.large])
                }
        // 사진 선택
        .sheet(isPresented: $isShowingPhotoSheet){
            PhotoSheetPickerSheet(openCamera: {
                isShowingPhotoSheet = false
                isShowingCamera = true
            }, onTapPhoto: { image in
                // 선택된 이미지 저장
                let imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
                selectedImage = (imageData, Image(uiImage: image))
                isShowingPhotoSheet = false
            }, openGallery: {
                isShowingPhotoSheet = false
                isShowingPhotoPicker = true
            })
            .presentationDetents([ .height(220)])
        }
        .photosPicker(isPresented: $isShowingPhotoPicker, selection: $selectedPhotoItem, matching: .images)
        .onChange(of: selectedPhotoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data){
                    selectedImage = (data, Image(uiImage: uiImage))
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            ImagePicker(image: $selectedImage, sourceType: .camera)
                .ignoresSafeArea()
            
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
            PostTitleView(title: selectedTab == .expense ? "지출 금액" : "절약 금액", isNeccessary: true)
            HStack {
                if selectedTab == .expense {
                    TextField("", text: $price, prompt:
                                Text("오늘 쓴 금액을 기록해 주세요")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color.black200)
                    )
                    .disabled(selectedTab == .noExpense)
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
                if selectedTab == .expense {
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
                TextEditor(text: $description)
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black700)
                    .focused($isMemoFocused)
                    .onSubmit {
                        isMemoFocused = false
                    }
                    .onChange(of: description) { newValue in
                        if newValue.count > 30 {
                            description = String(newValue.prefix(30))
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)


                // 2. 글자가 비어있을 때만 보여주는 Placeholder
                if description.isEmpty {
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
            // 업로드 별점
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
            
            // 업로드된 사진
            if let contentImage = selectedImage?.image {
                contentImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 84, height: 84)
                    .rounded(radius: 12)
                    .overlay(alignment: .topTrailing) {
                        Button {
                            // 사진 삭제
                            self.selectedImage = nil
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundStyle(Color.orange500)
                                .padding(4)
                        }
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
            isShowingPhotoSheet = true
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
    
    private func isSubmitButtonDisabled() -> Bool {
        return (selectedTab == .expense) ? ((Int(price) ?? 0 <= 0) || viewModel.selectedCategory == nil) : (viewModel.selectedCategory == nil)
    }
    
}

#Preview {
    let di = MockMainDIContainer()
    let coordinator = di.makeChallengeCoordinator(appCoordinator: di.makeAppCoordinator())
    di.makeFeedPostView(challengeId: 1, coordinator: coordinator)
    
}
