//
//  FeedCardView.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI
import Kingfisher

struct FeedCardView: View {
    let viewData: FeedCardViewData
    @Binding var isMenuOpen: Bool
    let onReport: () -> Void
    let onReportUser: () -> Void
    let onBlock: () -> Void
    
    var body: some View {
        VStack (alignment: .leading, spacing: .zero){
            
            // 카테고리, 메뉴
            HStack(alignment: .center, spacing: .zero) {
                Text(viewData.category)
                    .font(.pretendard(.regular , size: 12))
                    .foregroundStyle(.black600)
                
                Spacer()
                
                
                // 메뉴 버튼
                if !viewData.isMine {
                    Button {
                        isMenuOpen = true
                    } label: {
                        Image("icon_three_dot")
                            .resizable()
                            .frame(width: 17, height: 3)
                            .padding(.vertical, 8.5)
                    }
                }
            }
            .padding(.bottom, 4)
            
            
            // 내용
            HStack (alignment: .top, spacing: 8){
                VStack (alignment: .leading, spacing: .zero){
                    Text(viewData.authorNickname)
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(.black600)
                        .padding(.bottom,4)
                    
                    Text(viewData.content)
                        .font(.pretendard(.medium, size: 12))
                        .foregroundStyle(.black600)
                        .padding(.bottom, 8)
                    
                    Spacer()
                    
                    Text(viewData.price)
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(.black600)
                }
                Spacer()
                
                // 이미지
                if let image = viewData.imageUrl {
                    KFImage(URL(string: image))
                        .placeholder {
                            Placeholder()
                                .frame(width: 85, height: 85)
                                .rounded(radius: 12)
                        }
                        .retry(maxCount: 3, interval: .seconds(2))
                        .onFailure { error in
                            Logger.error("Image load failed: \(error.localizedDescription)")
                        }
                        .fade(duration: 0.25)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 85, height: 85)
                        .rounded(radius: 12)
                } 
                
            }
            .padding(.bottom, 10)
            
            // 좋아요, 날짜
            HStack(alignment: .center, spacing: .zero) {
                
                // 좋아요 버튼
                /*
                Button {
                    
                } label: {
                    HStack{
                        Image("thumb")
                        Text("\(viewData.likeCount)")
                            .font(.pretendard(.regular, size: 12))
                            .foregroundStyle(.black600)
                    }
                    .frame(minWidth: 50, alignment: .leading)
                }
                */
                Spacer()

                Text(viewData.date)
                    .font(.pretendard(.regular, size: 12))
                    .foregroundStyle(.black600)
            }
        }
        .overlay(alignment: .topTrailing, content: {
            if isMenuOpen {
                PopoverMenu(items: [
                    .init(title: "게시물 신고", icon: "icon_alert_triangle") {
                        onReport()
                    },
                    .init(title: "사용자 신고", icon: "icon_alert_triangle") {
                        onReportUser()
                    },
                    .init(title: "사용자 차단", icon: "icon_frown") {
                        onBlock()
                    }
                ], isPresented: $isMenuOpen)
            }
        })
        .padding(.vertical, 16)
        .padding(.horizontal, 17)
        .roundedBorder(color: .black100, radius: 12)
    }
}

#Preview {
    
    struct PreviewWrapper: View {
        
        @State private var isMenuOpen = false
        
        var body: some View {
            FeedCardView(viewData: FeedCardViewData(
                feedId: 10,
                authorId: 10,
                authorNickname: "오므라이스 최고",
                category: "카페/디저트",
                content: "텀블러에 담아서 먹었는데 그럭저럭 먹을만하더라구요. 다들 맛있게 절약하세요.",
                price: "+3,500원",
                likeCount: 3,
                date: "2027.09.18 18:30",
                imageUrl: "https://picsum.photos/50/50",
                isMine: true
                
            ), isMenuOpen: $isMenuOpen,
                         onReport: {},
                         onReportUser: {},
                         onBlock: {}
            )
            
        }
    }
    return PreviewWrapper()
}
