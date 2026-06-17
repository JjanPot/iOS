//
//  ImageDetailView.swift
//  jjanpot
//
//  Created by 임주희 on 4/23/26.
//

import SwiftUI
import Kingfisher
import UIKit

struct ImageDetailView: View {
    let imageUrl: String

    var body: some View {
        VStack {
            Spacer()

            ZoomableImageView(imageUrl: imageUrl)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Spacer()
        }
    }
}

struct ZoomableImageView: UIViewRepresentable {
    let imageUrl: String

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)

        context.coordinator.imageView = imageView
        context.coordinator.scrollView = scrollView

        // Kingfisher로 이미지 로드
        if let url = URL(string: imageUrl) {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResult):
                    DispatchQueue.main.async {
                        imageView.image = imageResult.image
                        imageView.frame.size = imageResult.image.size
                        scrollView.contentSize = imageResult.image.size

                        // 초기 zoomScale을 이미지가 화면에 fit하게 계산
                        let scrollViewSize = scrollView.bounds.size
                        let imageSize = imageResult.image.size

                        let horizontalScale = scrollViewSize.width / imageSize.width
                        let verticalScale = scrollViewSize.height / imageSize.height
                        let minScale = min(horizontalScale, verticalScale, 1.0)

                        scrollView.minimumZoomScale = minScale
                        scrollView.setZoomScale(minScale, animated: false)
                    }
                case .failure(let error):
                    Logger.error("Image load failed: \(error.localizedDescription)")
                }
            }
        }

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var imageView: UIImageView?
        var scrollView: UIScrollView?

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            guard let imageView = imageView else { return }

            let offsetX = max(0, (scrollView.bounds.width - imageView.frame.width) / 2)
            let offsetY = max(0, (scrollView.bounds.height - imageView.frame.height) / 2)

            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
        }
    }
}

#Preview {
    ImageDetailView(imageUrl: "https://jjanpot-s3-bucket.s3.ap-northeast-2.amazonaws.com/images/certification/73baf961-a5ff-4c95-a1d9-743952c19661.jpeg")
    
//    ImageDetailView(imageUrl: "https://jjanpot-s3-bucket.s3.ap-northeast-2.amazonaws.com/images/certification/15a7840d-cf8b-423d-9186-609178d52d86.jpeg")
    
//    ImageDetailView(imageUrl: "https://jjanpot-s3-bucket.s3.ap-northeast-2.amazonaws.com/images/certification/614c407f-79eb-422e-9f85-ceaa70257515.jpeg")
    
//    ImageDetailView(imageUrl: "https://jjanpot-s3-bucket.s3.ap-northeast-2.amazonaws.com/images/certification/538041df-7fc5-4cae-955f-2bc15fff14c4.jpeg")
}
