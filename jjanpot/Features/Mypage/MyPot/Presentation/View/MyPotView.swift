//
//  MyPotView.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//

import SwiftUI
import Kingfisher

struct MyPotView: View {
    
    @StateObject var viewModel: MyPotViewModel
    private let coordinator: MainCoordinator
    
    init(viewModel: MyPotViewModel, coordinator: MainCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    @State var isShowLogoutPopup: Bool = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                MainHeader()
                
                Group {
                    profill
                    
                    Divider()
                    
                    // 메뉴 뷰
                    VStack(alignment: .leading, spacing: 40) {
                        
                        
                        MenuSection("앱 설정") {
                            MenuButton("알림 설정") {}
                        }
                        MenuSection("법적 정보 및 앱 정보") {
                            MenuButton("서비스 이용약관") {}
                            MenuButton("개인정보퍼리방침") {}
                            MenuButton("운영 정책") {}
                            MenuButton("마케팅 수신 동의 약관") {}
                        }
                        MenuSection("도움말") {
                            MenuButton("이용가이드 / FAQ") {}
                        }
                        
                        MenuSection("계정") {
                            MenuButton("로그아웃") {
                                isShowLogoutPopup = true
                            }
                            MenuButton("탈퇴하기") {}
                        }
                    } // ~메뉴 뷰
                    
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        }//ScrollView
        .popup(isPresented: $isShowLogoutPopup) {
            Modal(title: "로그아웃 하시겠습니까?", content: "다시 로그인해야 서비스를 이용할 수 있어요.")
                .buttons {
                    ModalButton(title: "취소", colorType: .secondary) {
                        isShowLogoutPopup = false
                    }
                    ModalButton(title: "로그아웃") {
                        viewModel.logout()
                    }
                }
        }
    }
    
    private var profill: some View {
        HStack(alignment: .center, spacing: 14) {
            placeholder
            Text("nickname")
                .font(.pretendard(.semiBold, size: 16))
                .foregroundStyle(Color.black900)
            
        }
    }
    private var placeholder: some View {
        Color.black100
            .overlay(alignment: .center) {
                Image("person")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
    }
}



#Preview {
    let di = MockMainDIContainer()
    di.makeMyPotView(coordinator: di.makeMainCoordinator())
}





