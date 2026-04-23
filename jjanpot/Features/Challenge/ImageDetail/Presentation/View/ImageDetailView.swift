//
//  ImageDetailView.swift
//  jjanpot
//
//  Created by 임주희 on 4/23/26.
//

import SwiftUI
import Kingfisher

struct ImageDetailView: View {
    let imageUrl: String
    
    var body: some View {
        VStack {
            Spacer()
            
            KFImage(URL(string: imageUrl))
                .placeholder {
                    Placeholder()
                        
                }
                .retry(maxCount: 3, interval: .seconds(2))
                .onFailure { error in
                    Logger.error("Image load failed: \(error.localizedDescription)")
                }
                .fade(duration: 0.25)
                .resizable()
                .scaledToFit()
                //.frame(width: 85, height: 85)
//                .clipShape(Rectangle())
            
            Spacer()
        }
    }
}

#Preview {
    ImageDetailView(imageUrl: "https://jjanpot-s3-bucket.s3.ap-northeast-2.amazonaws.com/images/certification/73baf961-a5ff-4c95-a1d9-743952c19661.jpeg")
    
//    ImageDetailView(imageUrl: "https://jjanpot-s3-bucket.s3.ap-northeast-2.amazonaws.com/images/certification/15a7840d-cf8b-423d-9186-609178d52d86.jpeg")
    
//    ImageDetailView(imageUrl: "https://jjanpot-s3-bucket.s3.ap-northeast-2.amazonaws.com/images/certification/614c407f-79eb-422e-9f85-ceaa70257515.jpeg")
    
//    ImageDetailView(imageUrl: "https://jjanpot-s3-bucket.s3.ap-northeast-2.amazonaws.com/images/certification/538041df-7fc5-4cae-955f-2bc15fff14c4.jpeg")
}
