//
//  InviteCodeView.swift
//  jjanpot
//
//  Created by 임주희 on 3/24/26.
//

import SwiftUI
import Combine

// 초대코드 입력 화면

final class InviteCodeViewModel: ObservableObject {
    @Published var inviteCodeErrorMessage: String? = nil
}

struct InviteCodeView: View {
    
    @StateObject var viewModel: InviteCodeViewModel
    @State var code: String = ""
    private let hasSkip: Bool
    
    init(viewModel: InviteCodeViewModel,hasSkip: Bool) {
        self._viewModel = StateObject(wrappedValue: viewModel)
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
                errorMessage: $viewModel.inviteCodeErrorMessage,
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
                            .underline()
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
    InviteCodeView(viewModel: InviteCodeViewModel(), hasSkip: true)
}
