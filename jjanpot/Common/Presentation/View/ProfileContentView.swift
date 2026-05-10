//
//  ProfileContentView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI
import Kingfisher

struct ProfileContentView: View {
    @Binding var imageSource: ProfileImageSource?
    @Binding var nickname: String
    @Binding var nicknameErrorMessage: String?
    let onSubmit: (() -> Void)?
    let onProfileImageTapped: (() -> Void)?
    
    private var placeholderImage: some View {
        Color.black100
            .overlay(alignment: .center) {
                Image(systemName: "camera.fill")
                    .renderingMode(.template)
                    .foregroundStyle(Color.black300)
            }
    }

    var body: some View {
        
        VStack(alignment: .leading, spacing: 40) {
            
            // 프로필 이미지
            HStack(alignment: .center, spacing: 10) {
                
                
                Group {
                    switch imageSource {
                    case .local(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .network(let urlString):
                        if let url = URL(string: urlString) {
                            KFImage(url)
                                .resizable()
                                .scaledToFill()
                        } else {
                            placeholderImage
                        }
                    case nil:
                        placeholderImage
                    }
                }
                .frame(width: 66, height: 66)
                .clipShape(Circle())
                
                    
                
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
            ) {
                hideKeyboard()
                onSubmit?()
            }
        }
        
    }
}

#Preview {
    ProfileContentView(
        imageSource: .constant(nil),
        nickname: .constant(""),
        nicknameErrorMessage: .constant(nil),
        onSubmit: {},
        onProfileImageTapped: {}
    )
}
