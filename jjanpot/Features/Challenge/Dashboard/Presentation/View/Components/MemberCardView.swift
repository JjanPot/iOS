//
//  MemberCardView.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI
import Kingfisher


struct MemberCardViewData {
    let imageUrl: String
    let color: Color
    let name: String
    let amount: Int
}

struct MemberCardView: View {
    let viewData: MemberCardViewData
    
    
    
    var body: some View {
        VStack (alignment: .center, spacing: 10){
            KFImage(URL(string: viewData.imageUrl))
                .placeholder {
                    Image("person")
                        .frame(width: 24, height: 24)
                }
                .retry(maxCount: 3, interval: .seconds(2))
                .onFailure { error in
                    Logger.error("Image load failed: \(error.localizedDescription)")
                }
                .fade(duration: 0.25)
                .resizable()
                .frame(width: 44, height: 44)
                .scaledToFill()
                .background(Color.black100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(viewData.color, lineWidth: 2)
                )
            
            VStack (alignment: .center, spacing: 2){
                Text(viewData.name)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(.black500)
                
                Text("\(viewData.amount)")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(.black500)
            }
        }
    }
}

#Preview {
    MemberCardView(
        viewData: MemberCardViewData(
            imageUrl: "https://picsum.photos/50/50",
            color: .blue,
            name: "닉네임",
            amount: 10000)
    )
}
