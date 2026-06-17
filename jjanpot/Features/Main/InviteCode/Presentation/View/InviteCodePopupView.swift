//
//  InviteCodePopupView.swift
//  jjanpot
//
//  Created by 임주희 on 3/27/26.
//

import SwiftUI

// 초대코드 복사, 입력 뷰

struct InviteCodePopupView: View {
    
    enum InvireViewType {
        case viewer(code: String) // 멤버들에게 공유할 코드
        case inputForm(code: String?) //딥링크로 받아온 코드 (입력할거임)
        
        var title: String {
            switch self {
            case .viewer: "팀원을 초대하고 챌린지를 같이해요"
            case .inputForm: "팀장에게 받은 코드를 입력하세요"
            }
        }
        
        var subTitle: String {
            switch self {
            case .viewer: "초대 코드를 복사하고 팀원을 초대해 보세요."
            case .inputForm: "초대 코드를 입려하고 함께 절약을 시작해요."
            }
        }
    }
    
    @StateObject var viewModel: InviteCodeViewModel
    let onCloseAction: () -> Void
    
    init(viewModel: InviteCodeViewModel, viewType: InvireViewType, onCloseAction: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onCloseAction = onCloseAction
        self.viewType = viewType
        
        if case .inputForm(let code) = viewType, let code {
            // 딥링크로 코드 받아옴.
            _inputCode = State(initialValue: code)
        } else {
            _inputCode = State(initialValue: "")
        }
    }
    
    @State var inputCode: String = ""
    @State var isError: Bool = false
    @State var showShareSheet = false
    @FocusState private var isFocused: Bool
    private let viewType: InvireViewType
    
    var body: some View {
        VStack(alignment: .center, spacing: 42){
            VStack(alignment: .center, spacing: 26){
                
                Color.black100
                    .frame(width: 60, height: 4)
                    .clipShape(Capsule())
                
                VStack(alignment: .center, spacing: 3){
                    Text(viewType.title)
                        .font(.pretendard(.semiBold, size: 20))
                        .foregroundStyle(Color.black900)
                    Text(viewType.subTitle)
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(Color.black400)
                }
                
                Image("charater2")
                
                VStack(alignment: .center, spacing: 2) {
                    // 초대코드 복사뷰
                    if case let .viewer(inviteCode)  = viewType {
                        Text("내 초대 코드")
                            .font(.pretendard(.medium, size: 17))
                        
                        // 공유버튼 (초대코드 + 쉐어이미지)
                        Button {
                            // 공유시트 띄우기
                            viewModel.isLoading = true
                            showShareSheet = true
                            
                        } label: {
                            HStack(alignment: .center, spacing: 7) {
                                // 초대코드
                                Text(inviteCode)
                                    .font(.pretendard(.semiBold, size: 26))
                                    .foregroundStyle(Color.black)
                                
                                // 공유 버튼 이미지
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(Color.black400)
                                    .offset(y: -1)
                            }
                        }
                        .padding(.leading, 20)
                        
                        // 초대코드 입력뷰
                    } else  if case .inputForm = viewType {
                        
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
                // 키보드 내리기
                isFocused = false
                
                if viewType == .viewer(code: "") || inputCode.isEmpty {
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
        .onChange(of: viewModel.isSuccess) { isSuccess in
            if isSuccess {
                NotificationCenter.default.post(name: .shouldRefreshMain, object: nil)
                onCloseAction()
            }
        }
        .sheet(isPresented: $showShareSheet, onDismiss: {
            viewModel.isLoading = false
        }) {
            if case let .viewer(inviteCode)  = viewType {
                let url = "https://jjanpot.shop/invite?code=\(inviteCode)"
                let message = """
                    짠팟에서 챌린지 같이 해요! 아래 링크를 눌러 우리 팀에 바로 들어와요.
                    
                    (팀에 못 들어간 경우 로그인 후에 팀 코드 [\(inviteCode)] 를 직접 입력해 주세요!)

                    
                    👉 초대 링크: \(url)
                    """
                
                ShareSheet(items: [message], title: "짠팟 | 초대링크 공유", showImagePreview: false)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    MockMainDIContainer().makeInviteCodePopupView(invireViewType: .viewer(code: "aaabbb"), onCloseAction: {})
        .padding(20)
        .border(.red)
}



extension InviteCodePopupView.InvireViewType: Equatable {
    static func == (lhs: InviteCodePopupView.InvireViewType, rhs: InviteCodePopupView.InvireViewType) -> Bool {
        switch (lhs, rhs) {
        case (.viewer, .viewer): return true
        case (.inputForm, .inputForm): return true
        default: return false
        }
    }
}
