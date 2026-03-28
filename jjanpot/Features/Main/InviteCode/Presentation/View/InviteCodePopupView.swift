//
//  InviteCodePopupView.swift
//  jjanpot
//
//  Created by 임주희 on 3/27/26.
//

import SwiftUI

// 초대코드 복사, 입력 뷰

struct InviteCodePopupView: View {
    
    enum Viewer {
        case leader
        case member
        
        var title: String {
            switch self {
            case .leader: "팀원을 초대하고 챌린지를 같이해요"
            case .member: "팀장에게 받은 코드를 입력하세요"
            }
        }
        
        var subTitle: String {
            switch self {
            case .leader: "초대 코드를 복사하고 팀원을 초대해 보세요."
            case .member: "초대 코드를 입려하고 함께 절약을 시작해요."
            }
        }
    }
    
    @StateObject var viewModel: InviteCodePopupViewModel
    let inviteCode: String?
    let onCloseAction: () -> Void
    
    init(viewModel: InviteCodePopupViewModel, inviteCode: String?, onCloseAction: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.inviteCode = inviteCode
        self.onCloseAction = onCloseAction
        
        if let inviteCode, inviteCode.isNotEmpty {
            viewer = .leader
        } else {
            viewer = .member
        }
    }
    
    @State var inputCode: String = ""
    @State var isError: Bool = false
    @FocusState private var isFocused: Bool
    
//    private let title: String
//    private let subTitle: String
    private let viewer: Viewer
    
    var body: some View {
        VStack(alignment: .center, spacing: 42){
            VStack(alignment: .center, spacing: 26){
                
                Color.black100
                    .frame(width: 60, height: 4)
                    .clipShape(Capsule())
                
                VStack(alignment: .center, spacing: 3){
                    Text(viewer.title)
                        .font(.pretendard(.semiBold, size: 20))
                        .foregroundStyle(Color.black900)
                    Text(viewer.subTitle)
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
                            ToastManager.shared.show("초대 코드가 복사되었습니다.")
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
                        .focused($isFocused)
                        .multilineTextAlignment(.center)
                        .font(.pretendard(.semiBold, size: 26))
                        .foregroundStyle(isError ? Color.red500 : Color.black)
                        .onSubmit {
                            // 키보드 내리기
                            isFocused = false
                            viewModel.checkInviteCode(inputCode)
                        }
                    }
                }
                .padding(.vertical, 17)
                .frame(maxWidth: .infinity)
                .roundedBorder(color: .black100, radius: 12)
                .padding(.horizontal, 40)
            }
            
            MainButton(title: "확인") {
                if viewer == .leader || inputCode.isEmpty {
                    onCloseAction()
                } else {
                    // 입력 코드 확인하기 -> 맞으면 자동으로 닫기
                    viewModel.checkInviteCode(inputCode)
                }
            }
        }
        .padding()
        .background(Color.white)
        .rounded(radius: 12)
    }
}

#Preview {
    InviteCodePopupView(viewModel: InviteCodePopupViewModel(), inviteCode: nil, onCloseAction: {})
        .padding(20)
        .border(.red)
}

