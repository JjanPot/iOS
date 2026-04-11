//
//  ChallengeDashboardView.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//

import SwiftUI

// 챌린지 대시보드
struct ChallengeDashboardView: View {
    @StateObject var viewModel: ChallengeDashboardViewModel
    private let coordinator: MainCoordinator
    
    // 피드 메뉴 띄우기
    @State var selectedFeedIdForMenu: Int?
    
    // 신고완료 팝업
    @State var isShowReportedPopup: Bool = false
    
    
    init(viewModel: ChallengeDashboardViewModel, coordinator: MainCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        ZStack {
            VStack {
                Color.orange50
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 300)
                Color.clear
            }
            
            ScrollView {
                VStack (alignment: .leading, spacing: .zero){

                    // MARK: 오버뷰 //
                    VStack (alignment: .center, spacing: .zero){

                        HStack {
                            Spacer()
                        }
                        .frame(height: 30)

                        ChallengeOverview(viewData: viewModel.viewData, onSelectedMember: { selectedMember in
                            guard !selectedMember.isMe else { return }
                            coordinator.activeSheet = .reportUser(onReportUser: {
                                coordinator.activeSheet = nil
                                
                                guard let challengeId =  viewModel.viewData?.challengeId
                                else { return }
                                // 사용자 신고하기 모달띄우기
                                showReportUserModal(
                                    authorId: selectedMember.userId,
                                    challengeId: challengeId,
                                    authorNickname: selectedMember.nickname
                                )
                                
                            }, onBlockUser: {
                                coordinator.activeSheet = nil
                                guard let challengeId =  viewModel.viewData?.challengeId else { return }
                                
                                // 사용자 차단하기 모달 띄우기
                                showBlockModal(authorId: selectedMember.userId, challengeId: challengeId, authorNickname: selectedMember.nickname)
                            })
                        })
                    }
                    .background(Color.orange50)

                    // MARK: 피드 //
                    VStack (alignment: .leading, spacing: 12){

                        HStack() {
                            Spacer()
                            Text("모든 게시글")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundStyle(.black500)
                                .padding(.top, 24)
                            Spacer()
                        }
                        .padding(.bottom, 12)

                        // 게시물 목록 //
                        switch viewModel.viewData {
                        case let .inProgress(challengeId, _, feeds):
                            Group {
                                ForEach(feeds) { feed in
                                    switch feed {
                                    case let .header(_, date):
                                        FeedHeaderView(title: date)

                                    case let .item(_, feed):
                                        FeedCardView(viewData: feed,
                                                     isMenuOpen: Binding(
                                                        get: { selectedFeedIdForMenu == feed.feedId },
                                                        set: { isOpen in
                                                            if isOpen {
                                                                selectFeedForMenu(id: feed.feedId)
                                                            } else {
                                                                closeMenu()
                                                            }
                                                        }),
                                                     onReport: {
                                            // 게시글 신고하기 모달 띄우기
                                            showReportFeedModal(feedId: feed.feedId)
                                            
                                        }, onReportUser: {
                                            // 사용자 신고하기 모달 띄우기
                                            showReportUserModal(
                                                authorId: feed.authorId,
                                                challengeId: challengeId,
                                                authorNickname: feed.authorNickname
                                            )
                                            
                                        }, onBlock: {
                                            
                                            // 사용자 차단하기 모달 띄우기
                                            showBlockModal(authorId: feed.authorId, challengeId: challengeId, authorNickname: feed.authorNickname)
                                        })

                                    case .bottom:
                                        Spacer()
                                            .frame(height: 28)
                                    }
                                }
                            }.padding(.horizontal, 20)

                        default: // 피드 없을
                            Spacer()
                        }

                        Spacer()

                    }
                    .background(Color.white)

                }
            } // ScrollView
            .simultaneousGesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { _ in
                        closeMenu()
                    }
            )
            .onTapGesture {
                closeMenu()
            }
            
        } //Zstack
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .task {
            viewModel.loadChallengeDashboard()
        }
        .popup(isPresented: $isShowReportedPopup) {
            Modal(title: "신고가 접수되었습니다.", content: "24시간 이내 운영자 검토 후 서비스 이용 제한 등의 조치가 이루어질 수 있어요.")
                .buttons {
                    
                    ModalButton(title: "확인") {
                        isShowReportedPopup = false
                    }
                }
        }
    }
    
    /// 메뉴 열기/닫기
    func selectFeedForMenu(id: Int) {
        selectedFeedIdForMenu = id
    }

    /// 메뉴 닫기
    private func closeMenu() {
        if selectedFeedIdForMenu != nil {
            selectedFeedIdForMenu = nil
        }
    }
    
    // 게시글 신고하기 모달 띄우기
    private func showReportFeedModal(feedId: Int){
        coordinator.showReportModal(
            title: "게시글을 신고할까요?",
            content: "허위로 신고한 사용자에게는 불이익이 있을 수 있어요.",
            confirmButtonTitle: "신고하기",
            onConfirm: {
                coordinator.activePopup = .reportFeedReason(feedId: feedId, confirmAction: {
                    isShowReportedPopup = true
                    // 게시물 비노출
                    viewModel.removeFeed(feedId: feedId)
                })
            })
    }
    
    
    // 사용자 신고하기 모달띄우기
    private func showReportUserModal(authorId: Int, challengeId: Int, authorNickname: String){
        coordinator.showReportModal(
            title: "\(authorNickname)님을 신고할까요?",
            content: "허위로 신고한 사용자에게는 불이익이 있을 수 있어요.",
            confirmButtonTitle: "신고하기",
            onConfirm: {
                // 차단 이유 선택지 띄우기
                coordinator.activePopup = .reportUserReason(
                    userId: authorId,
                    challengeId: challengeId,
                    confirmAction: {
                    isShowReportedPopup = true
                })
            })
    }
    
    
    // 사용자 차단하기 모달 띄우기
    private func showBlockModal(authorId: Int, challengeId: Int, authorNickname: String){
        coordinator.showReportModal(
            title: "\(authorNickname)님을 차단할까요?",
            content: "\(authorNickname)님을 차단하면 챌린지 소식을 볼 수 없고, 2인 챌린지라면 챌린지가 즉시 종료돼요.",
            confirmButtonTitle: "차단하기",
            onConfirm: {
                coordinator.activePopup = nil
                
                // 유저 차단하기
                viewModel.blockUser(userId: authorId, challengeId: challengeId)
            })
    }
}

#Preview {
    let di = MockMainDIContainer()
    di.makeChallengeDashboardView(coordinator: di.makeMainCoordinator())
}
