//
//  AppFont.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import Foundation
import SwiftUI

// MARK: - Font Protocol
/// 모든 폰트가 구현해야 하는 프로토콜
protocol FontWeightProtocol {
    var fontName: String { get }
}

// MARK: - Font Family
enum AppFont {
    case pretendard(Pretendard)
    
    var fontName: String {
        switch self {
        case .pretendard(let weight):
            return weight.fontName
        }
    }
}

// MARK: - Pretendard

enum Pretendard: String, FontWeightProtocol {
    case black = "Pretendard-Black"
    case bold = "Pretendard-Bold"
    case extraBold = "Pretendard-ExtraBold"
    case extraLight = "Pretendard-ExtraLight"
    case light = "Pretendard-Light"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
    case semiBold = "Pretendard-SemiBold"
    case thin = "Pretendard-Thin"

    var fontName: String {
        return rawValue
    }
}

// MARK: - Font Extension

extension Font {
    /// Pretendard 폰트를 Font 타입으로 반환
    /// - Parameters:
    ///   - weight: Pretendard weight
    ///   - size: 폰트 크기
    /// - Returns: SwiftUI Font
    static func pretendard(_ weight: Pretendard, size: CGFloat) -> Font {
        return Font.custom(weight.fontName, size: size)
    }
}

