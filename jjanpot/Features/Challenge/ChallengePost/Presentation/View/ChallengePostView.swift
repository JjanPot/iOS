//
//  ChallengePostView.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI
import PhotosUI
import Photos

enum ChallengePostTab {
    case expense // 지출
    case noExpense // 무지출
}


struct ChallengePostView: View {
    @StateObject var viewModel: ChallengePostViewModel
//    private let coordinator: MainCoordinator
    
    init(viewModel: ChallengePostViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
//        self.coordinator = coordinator
    }
    
    
    @State var selectedTab: ChallengePostTab = .expense
    @State var selectedCategory: CategorySelectorViewData? = nil
    @State var price: String = ""
    @State var description: String = ""
    
    @FocusState private var isPriceFocused: Bool
    @FocusState private var isMemoFocused: Bool
    
    @State private var isShowingPicker = false
    @State var date: Date = Date()
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isShowingPhotoPicker = false
    @State var selectedImage: Image? = nil
    // 앨범 접근 권한 재요청
    @State private var showPermissionAlert = false
    
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SegmentedToggleView(selectedTab: $selectedTab)
                
                // 카테고리
                CategorySelector(
                    selected: $selectedCategory,
                    categories: [
                        .init(title: "카페/디저트", icon: "icon_category_cafe"),
                        .init(title: "교통", icon: "icon_category_car"),
                        .init(title: "패션/뷰티", icon: "icon_category_car"),
                    ])
                
                
                // 금액
                priceTextField
                
                // 메모
                memoTextField
                
                // 등록일시
                dateField
                
                // 사진 업로드
                images
                
                MainButton(title: "등록하기", isDisabled: price.isEmpty || selectedCategory == nil) {
                    print(">>>>> 등록하기")
                }
                
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("인증하기")
        .scrollDismissesKeyboard(.interactively)
        .sheet(isPresented: $isShowingPicker) {
            VStack(spacing: 10) {
                        DatePicker(
                            "날짜를 선택하세요",
                            selection: $date,
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
                   let uiImage = UIImage(data: data) {
                    //viewModel.profileImage = Image(uiImage: uiImage)
                    selectedImage = Image(uiImage: uiImage)
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
    }
    
    // 금액
    private var priceTextField: some View {
        VStack(alignment: .leading, spacing: 10) {
            PostTitleView(title: "금액", isNeccessary: true)
            HStack {
                TextField("", text: $price, prompt:
                            Text("오늘 쓴 금액을 기록해 주세요")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black200)
                )
                .keyboardType(.numberPad)
                .focused($isPriceFocused)
                .font(.pretendard(.regular, size: 14))
                .foregroundColor(Color.black700)
                .onSubmit {
                    isPriceFocused = false
                }


                Text("원")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black700)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .roundedBorder(color: .black100, radius: 12)
        }
    }
    
    private var memoTextField: some View {
        VStack(alignment: .leading, spacing: 10) {
            PostTitleView(title: "메모", isNeccessary: true)

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
    
    // 등록일시
    private var dateField: some View {
        HStack(spacing: .zero){
            PostTitleView(title: "등록일시", isNeccessary: false)
            Spacer()
            
            Button {
                isShowingPicker = true
            } label: {
                HStack(spacing: 10) {
                    Text(date.toString(format: "M월 d일 hh:mm", locale: .kr))
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(Color.black500)
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.black500)
                }
            }
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
                
                // 업로드된 사진
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .frame(width: 84, height: 84)
                        .rounded(radius: 12)
                }
            }
            
        }
    }
    
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
    di.makeChallengePostView(challengeId: 1)
}
