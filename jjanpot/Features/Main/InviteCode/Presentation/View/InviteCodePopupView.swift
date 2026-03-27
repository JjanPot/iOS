//
//  InviteCodePopupView.swift
//  jjanpot
//
//  Created by 임주희 on 3/27/26.
//

import SwiftUI

// 초대코드 복사, 입력 뷰

struct InviteCodePopupView: View {
    
    @StateObject var viewModel: InviteCodePopupViewModel
    let inviteCode: String?
    let onComfirmAction: () -> Void
    
    init(viewModel: InviteCodePopupViewModel, inviteCode: String?, onComfirmAction: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.inviteCode = inviteCode
        self.onComfirmAction = onComfirmAction
    }
    
    @State var inputCode: String = ""
    @State var isError: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 42){
            VStack(alignment: .center, spacing: 26){
                
                Color.black100
                    .frame(width: 60, height: 4)
                    .clipShape(Capsule())
                
                VStack(alignment: .center, spacing: 3){
                    Text("팀장에게 받은 코드를 입력하세요")
                        .font(.pretendard(.semiBold, size: 20))
                        .foregroundStyle(Color.black900)
                    Text("초대 코드를 입려하고 함께 절약을 시작해요.")
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(Color.black400)
                }
                
                Image("charater2")
                    
                VStack(alignment: .center, spacing: 2) {
                    // 초대코드 있음 -> 복사뷰
                    if let inviteCode {
                        Text("내 초대 코드")
                            .font(.pretendard(.medium, size: 17))
                
                        Button {
                            // 초대코드 클립보드에 복사
                            UIPasteboard.general.string = inviteCode
                            // TODO: 토스트메세지띄우기
                        } label: {
                            HStack(alignment: .center, spacing: 7) {
                                Text(inviteCode)
                                    .font(.pretendard(.semiBold, size: 26))
                                    .foregroundStyle(Color.black)
                                Image("icon_copy")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                            }
                        }
                    } else {
                        // 초대코드 없음 -> 입력뷰
                        Text("받은 초대 코드")
                            .font(.pretendard(.medium, size: 17))
                        
                        TextField("", text: $inputCode,
                                  prompt:
                                    Text("코드 입력")
                        )
                        .multilineTextAlignment(.center)
                        .font(.pretendard(.semiBold, size: 26))
                        .foregroundStyle(isError ? Color.red500 : Color.black)
                    }
                }
                .padding(.vertical, 17)
                .frame(maxWidth: .infinity)
                .roundedBorder(color: .black100, radius: 12)
                .padding(.horizontal, 40)
            }
            
            MainButton(title: "확인") {
                //닫기
                onComfirmAction()
            }
        }
        .padding()
        .background(Color.white)
        .rounded(radius: 12)
    }
}

#Preview {
    InviteCodePopupView(viewModel: InviteCodePopupViewModel(), inviteCode: nil, onComfirmAction: {})
        .padding(20)
        .border(.red)
}

