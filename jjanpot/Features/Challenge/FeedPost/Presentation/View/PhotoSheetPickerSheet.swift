//
//  PhotoSheetPickerSheet.swift
//  jjanpot
//
//  Created by 임주희 on 6/28/26.
//

import SwiftUI
import Photos
import UIKit


struct PhotoCell: View {
    var image: UIImage?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.black100
            }
        }
        .frame(width: 84, height: 84)
        .clipped()
        .rounded(radius: 12)
    }
}


// MARK: - PhotoSheetPickerSheet

struct PhotoSheetPickerSheet: View {

    var openCamera: ()->Void
    var onTapPhoto: (UIImage)->Void
    var openGallery: ()->Void

    @State private var albumPhotos: [UIImage] = []

    var body: some View {
        NavigationView {
           
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    // 카메라 열기
                    Button {
                        openCamera()
                    } label: {
                        cameraCell
                    }
                    ForEach(0..<min(10, albumPhotos.count), id: \.self) { index in
                        Button {
                            onTapPhoto(albumPhotos[index])
                        } label: {
                            PhotoCell(image: albumPhotos[index])
                        }
                    }
                    
                    // 앨범으로
                    Button {
                        openGallery()
                    } label: {
                        photoMoreCell
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom)
            } //~ScrollView
            .navigationTitle("사진 선택")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .onAppear {
            fetchAlbumPhotos()
        }
    }
    
    private var cameraCell: some View {
        Color.black100
            .overlay(alignment: .center) {
                Image("camera")
                    .resizable()
                    .frame(width: 23, height: 23)
                    .foregroundStyle(.black300)
            }
            .frame(width: 84, height: 84)
            .rounded(radius: 12)
    }
    
    private var photoMoreCell: some View {
        Color.black100
            .overlay(alignment: .center) {
                Image(systemName: "photo.fill.on.rectangle.fill")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.black300)
                    .frame(width: 26, height: 23)
            }
            .frame(width: 84, height: 84)
            .rounded(radius: 12)
    }

    // 사진 불러오기
    private func fetchAlbumPhotos() {
        var photos: [UIImage] = []
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        let targetSize = CGSize(width: 84, height: 84)
        let limit = min(10, fetchResult.count)

        let group = DispatchGroup()

        for i in 0..<limit {
            let asset = fetchResult.object(at: i)
            group.enter()

            imageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: requestOptions
            ) { image, _ in
                if let image = image {
                    photos.append(image)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.albumPhotos = photos.sorted {
                photos.firstIndex(of: $0) ?? 0 < photos.firstIndex(of: $1) ?? 0
            }
        }
    }
}

// MARK: - ImagePicker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: (data: Data, image: Image)?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage,
               let imageData = uiImage.jpegData(compressionQuality: 0.8) {
                parent.image = (imageData, Image(uiImage: uiImage))
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    PhotoSheetPickerSheet(
        openCamera: {},
        onTapPhoto: { _ in },
        openGallery: {}
    )
}
