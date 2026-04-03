//
//  PhotoAuthManager.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


import Photos

class PhotoAuthManager {
    static func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        // 1. 현재 권한 상태 확인
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly) // 저장만 할 경우 .addOnly
        
        switch status {
        case .authorized, .limited:
            // 이미 권한이 있음
            completion(true)
        case .denied, .restricted:
            // 사용자가 거부했음
            completion(false)
        case .notDetermined:
            // 아직 결정하지 않음 (최초 요청)
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        @unknown default:
            completion(false)
        }
    }
}