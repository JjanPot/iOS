//
//  ProfileSetupView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI
import PhotosUI
import Photos

struct ProfileSetupView: View {
    @StateObject var viewModel: ProfileSetupViewModel
    private let coordinator: LoginCoordinator

    @State private var isShowingPicker = false
    @State private var selectedDate = Date()
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isShowingPhotoPicker = false
    
    // 앨범 접근 권한 재요청
    @State private var showPermissionAlert = false

    init(viewModel: ProfileSetupViewModel, coordinator: LoginCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }

 
    var body: some View {
        
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    
                    Text("프로필을 만들고\n함께 절약을 실펀하세요")
                        .font(.pretendard(.semiBold, size: 24))
                        .foregroundStyle(Color.black900)
                    
                    // 프로필 이미지, 닉네임
                    ProfileContentView(
                        profileImage: $viewModel.profileImage,
                        nickname: $viewModel.nickname,
                        nicknameErrorMessage: $viewModel.nicknameErrorMessage,
                        onSubmit: {
                            viewModel.setProfile()
                        },
                        onProfileImageTapped: {
                            requestPhotoLibraryPermission()
                        }
                    )
                    
                    // 생년월일
                    Button {
                        isShowingPicker = true
                    } label: {
                        DateTextField(
                            title: "생년월일",
                            placeHolder: "생년월일을 입력해 주세요.",
                            birthDate: $viewModel.birthDate,
                            isNeccessary: false
                        )
                    }
                    .onChange(of: selectedDate) { newValue in
                        viewModel.birthDate = newValue
                    }
                    
                    Spacer()
                }
                .padding(20)
                
            } // ~ScrollView
            
            MainButton(title: "다음", size: .large, colorType: .fill, isDisabled: (viewModel.nickname.isEmpty)) {
                hideKeyboard()
                viewModel.setProfile()
            }
            .padding(20)
        } // ~VStack
        .navigationTitle("프로필 생성")
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .sheet(isPresented: $isShowingPicker) {
                    VStack {
                        DatePicker(
                            "날짜를 선택하세요",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical) // 달력 형태로 표시
                        .padding()

                        Button("완료") {
                            isShowingPicker = false
                        }
                        .padding()
                    }
                    .presentationDetents([.medium]) // 화면 절반 정도 높이로 설정
                }
        .photosPicker(isPresented: $isShowingPhotoPicker, selection: $selectedPhotoItem, matching: .images)
        .onChange(of: selectedPhotoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    viewModel.profileImage = Image(uiImage: uiImage)
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
        .onChange(of: viewModel.isSuccess) { isSuccess in
            if isSuccess {
                coordinator.navigateToInviteCode()
            }
        }
    }
    
    
    // MARK: - methods..
    
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
    let mockDIContainer = MockLoginDIContainer()
    return mockDIContainer.makeProfileSetupView(coordinator: mockDIContainer.makeLoginCoordinator())
}
