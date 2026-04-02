//
//  Modal.swift
//  jjanpot
//
//  Created by 임주희 on 3/27/26.
//

import SwiftUI

struct Modal {
    let title: String
    let content: String?

    init(title: String, content: String? = nil) {
        self.title = title
        self.content = content
    }

    func buttons<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        ModalWithButtons(modal: self, buttons: content())
    }
}

private struct ModalWithButtons<Buttons: View>: View {
    let modal: Modal
    let buttons: Buttons

    var body: some View {
        VStack(alignment: .center, spacing: 20){

            // 제목, 컨텐츠
            VStack(alignment: .center, spacing: 12) {
                Text(modal.title)
                    .font(.pretendard(.semiBold, size: 20))
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    

                if let content = modal.content {
                    Text(content)
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(Color.black400)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            // 버튼
            HStack(spacing: 8) {
                buttons
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.top, 32)
        .padding([.bottom, .horizontal], 20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
    }
}



#Preview {
    PopupTestView()
}

struct PopupTestView: View {
    @State var isPresented: Bool = false
    @State var showSingleButton: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, World!")

            Button("1개 버튼 팝업") {
                showSingleButton = true
                isPresented = true
            }

            Button("2개 버튼 팝업") {
                showSingleButton = false
                isPresented = true
            }
        }
        .popup(isPresented: $isPresented) {
            if showSingleButton {
                Modal(title: "알림", content: "저장되었습니다")
                    .buttons {
                        ModalButton(title: "확인", size: .large) {
                            isPresented = false
                        }
                    }
            } else {
                Modal(title: "삭제", content: "정말 삭제하시겠습니까?")
                    .buttons {
                        ModalButton(title: "취소", size: .middle, colorType: .secondary) {
                            isPresented = false
                        }
                        ModalButton(title: "확인", size: .middle) {
                            print("삭제됨")
                            isPresented = false
                        }
                    }
            }
        }
    }
}
