//
//  ProfileEditView.swift
//  jjanpot
//
//  Created by 임주희 on 5/7/26.
//

import SwiftUI

/// 프로필 수정화면
struct ProfileEditView: View {
    @State var profileImage: Image? = nil
    @State var nickname: String = ""
    @State var nicknameErrorMessage: String? = ""
    @State var selectedDate: Date = Date()
    @State var birthDate: Date? = Date()
    
    
    @State var isShowingPicker: Bool = false
    
    
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    
                    // 프로필 이미지, 닉네임
                    ProfileContentView(
                        profileImage: $profileImage,
                        nickname: $nickname,
                        nicknameErrorMessage: $nicknameErrorMessage,
                        onSubmit: {
                            //viewModel.setProfile()
                        },
                        onProfileImageTapped: {
                            //requestPhotoLibraryPermission()
                        }
                    )
                    
                    // 생년월일
                    Button {
                        isShowingPicker = true
                    } label: {
                        DateTextField(
                            title: "생년월일",
                            placeHolder: "생년월일을 입력해 주세요.",
                            birthDate: $birthDate,
                            isNeccessary: false
                        )
                    }
                    .onChange(of: selectedDate) { newValue in
//                        viewModel.birthDate = newValue
                    }
                    
                    Spacer()
                }
                .padding(20)
                
            } // ~ScrollView
            
            MainButton(title: "다음", size: .large, colorType: .fill, isDisabled: (nickname.isEmpty)) {
                hideKeyboard()
//                viewModel.setProfile()
            }
            .padding(20)
        } // ~VStack
        .navigationTitle("프로필 수정")
//        .loading(viewModel.isLoading)
//        .toast(message: $viewModel.toastMessage)

    }
}

#Preview {
    ProfileEditView()
}

