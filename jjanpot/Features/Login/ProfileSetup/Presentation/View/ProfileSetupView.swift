//
//  ProfileSetupView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

struct ProfileSetupView: View {
    @StateObject var viewModel: ProfileSetupViewModel
    private let coordinator: LoginCoordinator
    
    @State private var isShowingPicker = false
    @State private var selectedDate = Date()

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
                        nickname: $viewModel.nickname,
                        nicknameErrorMessage: $viewModel.nicknameErrorMessage,
                        onProfileImageTapped: {
                            print(">>>>> 이미지 등록하기")
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
                coordinator.navigateToSignUpComplete()
            }
            .padding(20)
        } // ~VStack
        .navigationTitle("프로필 생성")
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
        
        
    }
}

#Preview {
    let mockDIContainer = MockLoginDIContainer()
    let coordinator = LoginCoordinator(loginDIContainer: mockDIContainer)
    return ProfileSetupView(viewModel: ProfileSetupViewModel(), coordinator: coordinator)
}
