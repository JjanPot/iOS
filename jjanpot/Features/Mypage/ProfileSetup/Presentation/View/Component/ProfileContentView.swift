//
//  ProfileContentView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

struct ProfileContentView: View {
    
    
    @Binding var nickname: String
    @Binding var nicknameErrorMessage: String?
    let onProfileImageTapped: (() -> Void)?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 40) {
            
            // 프로필 이미지
            HStack(alignment: .center, spacing: 10) {
                // placeHolder
                Color.black100
                    .frame(width: 66, height: 66)
                    .rounded(radius: 12)
                    .overlay(alignment: .center) {
                        Image(systemName: "camera.fill")
                            .renderingMode(.template)
                            .foregroundStyle(Color.black300)
                    }
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("프로필 이미지를 등록해주세요.")
                        .font(.pretendard(.medium, size: 14))
                    
                    Button {
                        onProfileImageTapped?()
                    } label: {
                        Text("이미지 등록하기")
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundStyle(Color.black400)
                            .underline()
                    }
                }
            }
            
            // 닉네임
            MainTextField(
                title: "닉네임",
                placeHolder: "최대 10글자까지 입력해 주세요.",
                textValue: $nickname,
                isNeccessary: true,
                textLimit: 10,
                errorMessage: $nicknameErrorMessage
            )
        }
        
    }
}

#Preview {
    ProfileContentView(
        nickname: .constant(""),
        nicknameErrorMessage: .constant(nil),
        onProfileImageTapped: {}
    )
}
