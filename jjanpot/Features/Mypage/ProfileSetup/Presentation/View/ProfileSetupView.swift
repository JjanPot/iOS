//
//  ProfileSetupView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

struct ProfileSetupView: View {
    @StateObject var viewModel: ProfileSetupViewModel
    init(viewModel: ProfileSetupViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
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
                        print(">>>>> 달력띄우기")
                    } label: {
                        DateTextField(
                            title: "생년월일",
                            placeHolder: "생년월일을 입력해 주세요.",
                            birthDate: $viewModel.birthDate,
                            isNeccessary: false
                        )
                    }
                    
                    // 성별
//                    VStack(alignment: .leading, spacing: 10) {
//                        HStack(spacing: .zero) {
//                            Text("성별")
//                                .font(.pretendard(.semiBold, size: 14))
//                                .foregroundStyle(Color.black600)
//                        }
//                    }
                    
                    Spacer()
                }
                .padding(20)
                
            } // ~ScrollView
            
            MainButton(title: "다음", size: .large, colorType: .fill, isDisabled: (viewModel.nickname.isEmpty)) {
                print(">>>>> 다음")
            }
            .padding(20)
        } // ~VStack
        
        
    }
}

#Preview {
    ProfileSetupView(viewModel: ProfileSetupViewModel())
}
