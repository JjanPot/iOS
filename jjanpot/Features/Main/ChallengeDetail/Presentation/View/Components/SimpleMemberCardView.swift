//
//  SimpleMemberCardView.swift
//  jjanpot
//
//  Created by 임주희 on 4/18/26.
//


import SwiftUI
import Kingfisher


struct SimpleMemberCardView: View {
    let viewData: MemberCardViewData
    
    var body: some View {
        HStack (alignment: .center, spacing: 6){
            
            // 이미지
            Group {
                if let imageUrl = viewData.imageUrl {
                    KFImage(URL(string: imageUrl))
                        .placeholder {
                            placeholder
                        }
                        .retry(maxCount: 3, interval: .seconds(2))
                        .onFailure { error in
                            Logger.error("Image load failed: \(error.localizedDescription)")
                        }
                        .fade(duration: 0.25)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 26, height: 26)
                } else {
                     placeholder
                }
            }
            .clipShape(Circle())
            .overlay(alignment: .bottomTrailing) {
                if viewData.isLeader {
                    Image("leaderMark")
                        .resizable()
                        .frame(width: 10, height: 10)
                }
            }

            // 닉네임
            Text(viewData.nickname)
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(.black500)
        }
    }
    
    private var placeholder: some View {
        Color.black100
            .overlay(alignment: .center) {
                Image("person")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .frame(width: 26, height: 26)
    }
}

#Preview {
    SimpleMemberCardView(
        viewData: MemberCardViewData(
            userId: 0,
            nickname: "닉네임",
            imageUrl: "https://picsum.photos/50/50",
            color: .blue,
            amount: 10000,
            isMe: false,
            isLeader: true,
            isBlocked: false
            
        )
    )
}
