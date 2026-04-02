//
//  MemberCardView.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI
import Kingfisher


struct MemberCardView: View {
    let viewData: MemberCardViewData
    
    var body: some View {
        VStack (alignment: .center, spacing: 10){
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
                        .frame(width: 44, height: 44)
                        .scaledToFill()
                } else {
                     placeholder
                }
            }
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(viewData.color, lineWidth: 2)
            )
            
            
            VStack (alignment: .center, spacing: 2){
                Text(viewData.nickname)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(.black500)
                
                Text("\(viewData.amount)")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(.black500)
            }
        }
    }
    
    private var placeholder: some View {
        Color.black100
            .overlay(alignment: .center) {
                Image("person")
                    .frame(width: 24, height: 24)
            }
            .frame(width: 44, height: 44)
    }
}

#Preview {
    MemberCardView(
        viewData: MemberCardViewData(
            userId: 0,
            nickname: "닉네임",
            imageUrl: "https://picsum.photos/50/50",
            color: .blue,
            amount: 10000)
    )
}
