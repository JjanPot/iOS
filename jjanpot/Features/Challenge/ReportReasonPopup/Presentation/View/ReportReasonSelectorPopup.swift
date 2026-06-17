//
//  ReportFeedPopup.swift
//  jjanpot
//
//  Created by 임주희 on 4/11/26.
//

import SwiftUI


enum ReportType {
    case feed(feedId: Int)
    case user(userId: Int, challengeId: Int)
    
}

protocol ReportReasonProtocol: CaseIterable {
    var popupTitle: String { get }
    var title: String { get }
    var code: String { get }
}

// 게시글 신고 이유 선택 팝업
struct ReportReasonSelectorPopup<Reason: ReportReasonProtocol & CaseIterable & Hashable>: View {
    @StateObject var viewModel: ReportReasonSelectorPopupViewModel
    @State private var selectedReason: Reason? = nil
    
    let reason: Reason
    let onConfirm: () -> Void
    let onClose: () -> Void
    
    init(viewModel: ReportReasonSelectorPopupViewModel,
         reason: Reason,
         onConfirm: @escaping () -> Void,
         onClose: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.reason = reason
        self.onConfirm = onConfirm
        self.onClose = onClose
    }

    var body: some View {
        VStack(alignment: .center, spacing: .zero) {

            Color.black100
                .frame(width: 60, height: 4)
                .clipShape(Capsule())

            VStack(alignment: .leading, spacing: 27) {

                // 팝업 타이틀
                Text(reason.popupTitle)
                    .font(.pretendard(.semiBold, size: 20))
                    .foregroundStyle(.black900)
                    

                // 선택지
                VStack(alignment: .leading, spacing: 22) {
                    ForEach(Array(Reason.allCases), id: \.self) { option in
                        Button(action: {
                            selectedReason = option
                        }) {
                            HStack {
                                Text((option as (any ReportReasonProtocol)).title)
                                    .font(.pretendard(.semiBold, size: 16))
                                    .foregroundStyle(.black400)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundStyle(selectedReason == option ? .orange500 : .black100)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 24)
            .padding(.bottom, 43)

            MainButton(title: "신고하기", isDisabled: (selectedReason == nil)) {
                if let selected = selectedReason {
                    viewModel.report(reason: selected.code)
                }
            }

        }
        .padding(20)
        .background(Color.white)
        .rounded(radius: 12)
        .onChange(of: viewModel.isSuccessed) { isSuccessed in
            if isSuccessed {
                onConfirm()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.3)

        MockMainDIContainer().makeReportReasonSelectorPopupView(
            reason: ReportFeedReason.inappropriateBehavior,
            reportType: .feed(feedId: 0),
            confirmAction: {  print("신고됨") },
            closeAction: { print("닫기") })
        .padding(20)
        //        .padding(20)
    }
}
