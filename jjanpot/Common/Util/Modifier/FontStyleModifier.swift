//
//  FontStyleModifier.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import Foundation
import UIKit
import SwiftUI

// 안쓸듯
public enum FontStyle {
    case H1
    case H2
    case H3
    case Body1
    case Body2
    case SubTitle1
    case SubTitle2
    case Btn1_b
    case Btn1
    case Btn2_b
    case Btn2
    case Caption
    case Caption_b
    case Label
    
    var name: String {
        switch self {
            
        case .H1:
            "Pretendard-SemiBold"
        case .H2:
            "Pretendard-SemiBold"
        case .H3:
            "Pretendard-SemiBold"
        case .Body1:
            "Pretendard-Regular"
        case .Body2:
            "Pretendard-Regular"
        case .SubTitle1:
            "Pretendard-SemiBold"
        case .SubTitle2:
            "Pretendard-SemiBold"
        case .Btn1_b:
            "Pretendard-SemiBold"
        case .Btn1:
            "Pretendard-Medium"
        case .Btn2_b:
            "Pretendard-SemiBold"
        case .Btn2:
            "Pretendard-Medium"
        case .Caption:
            "Pretendard-Regular"
        case .Caption_b:
            "Pretendard-SemiBold"
        case .Label:
            "Pretendard-Medium"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .H1: return 40
        case .H2: return 24
        case .H3: return 20
            
        case .Body1: return 16
        case .Body2: return 14
            
        case .SubTitle1: return 16
        case .SubTitle2: return 14
            
        case .Btn1_b: return 16
        case .Btn1: return 16
        case .Btn2_b: return 14
        case .Btn2: return 14

        case .Caption: return 12
        case .Caption_b: return 12
        case .Label: return 10
        }
    }
    
    var font: Font {
        .custom(self.name, size: self.size)
    }
}

public struct FontStyleModifier: ViewModifier {
    private var fontSize: CGFloat
    private var fontName: String
    
    public init(style fontStyle: FontStyle) {
        self.fontSize = fontStyle.size
        self.fontName = fontStyle.name
    }
    
    public func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: fontSize))
    }
}


public extension Text {
    func font(_ fontStyle: FontStyle) -> ModifiedContent<Text, FontStyleModifier> {
        modifier(FontStyleModifier(style: fontStyle))
    }
}
public extension TextField {
    func font(_ fontStyle: FontStyle) -> ModifiedContent<TextField, FontStyleModifier> {
        modifier(FontStyleModifier(style: fontStyle))
    }
}
