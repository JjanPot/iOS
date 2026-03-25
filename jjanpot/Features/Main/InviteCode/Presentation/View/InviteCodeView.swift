//
//  InviteCodeView.swift
//  jjanpot
//
//  Created by 임주희 on 3/24/26.
//

import SwiftUI

// 초대코드 입력 화면

struct InviteCodeView: View {
    
    private let hasSkip: Bool
    
    @State var code: String = ""
    
    init(hasSkip: Bool) {
        self.hasSkip = hasSkip
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20){
            Text("팀장에게 받은\n초대코드를 입력해주세요.")
                .font(.pretendard(.semiBold, size: 24))
                .foregroundStyle(Color.black900)
                .multilineTextAlignment(.leading)
            
            MainTextField(
                title: "초대코드",
                placeHolder: "초대 코드를 입력해주세요",
                textValue: $code,
                isNeccessary: false,
                textLimit: nil,
                keyboardType: .numberPad
            )
            
            
            Spacer()
            
            VStack(spacing: 22) {
                if hasSkip {
                    Button {
                        print(">>>>> 스킵")
                    } label: {
                        Text("초대코드가 없어요.")
                            .font(.pretendard(.regular, size: 14))
                            .foregroundStyle(Color.black500)
                    }
                }
                
                MainButton(title: "다음") {
                    print(">>>>> 다음")
                }
                
            }
            
        }
        .padding()
    }
}

#Preview {
    InviteCodeView(hasSkip: true)
}
