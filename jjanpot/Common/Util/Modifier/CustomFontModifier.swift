//
//  CustomFontModifier.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//


import Foundation
import UIKit
import SwiftUI

// MARK: - SwiftUI Modifier

struct CustomFontModifier: ViewModifier {
    private var fontSize: CGFloat
    private var fontName: String
    private var trackingPercent: CGFloat?

    init(_ font: AppFont, size: CGFloat, trackingPercent: CGFloat? = nil) {
        self.fontSize = size
        self.fontName = font.fontName
        self.trackingPercent = trackingPercent
    }

//    /55pt 텍스트: .tracking(-1.1) (55 × -2% = -1.1)/
    func body(content: Content) -> some View {
        let baseContent = content.font(.custom(fontName, size: fontSize))

        if let trackingPercent = trackingPercent {
            baseContent.tracking(fontSize * trackingPercent)
        } else {
            baseContent
        }
    }
}

// MARK: - SwiftUI Extension

extension View {
    /// AppFont를 사용하여 폰트 적용
    /// - Parameters:
    ///   - font: 적용할 폰트 (.pretendard(.bold) 형식)
    ///   - size: 폰트 크기
    func font(_ font: AppFont, size: CGFloat, trackingPercent: CGFloat? = nil) -> some View {
        self.modifier(CustomFontModifier(font, size: size, trackingPercent: trackingPercent))
    }
}

// MARK: - UIKit Helper

extension AppFont {
    /// UIFont 반환
    func uiFont(size: CGFloat) -> UIFont {
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}