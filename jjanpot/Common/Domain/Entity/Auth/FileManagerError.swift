//
//  FileManagerError.swift
//  jjanpot
//
//  Created by 임주희 on 5/10/26.
//

import Foundation

enum FileManagerError: LocalizedError {
    case documentsDirectoryNotFound
    case imageConversionFailed
    

    var errorDescription: String? {
        switch self {
        case .documentsDirectoryNotFound:
            return "Documents 디렉토리를 찾을 수 없습니다."
        case .imageConversionFailed:
            return "이미지를 JPEG 형식으로 변환하는데 실패했습니다."
        }
    }
}
