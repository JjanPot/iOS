//
//  CapsuleButton.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI


struct CapsuleButton: View {
    
    let title: String
    let size: CapsuleButtonSize
    let colorType: ButtonColorType
    let isDisabled: Bool
    let action: () -> Void
    
    @State private var isPressed: Bool = false
    
    init(title: String, size: CapsuleButtonSize = .middle, colorType: ButtonColorType, isDisabled: Bool, action: @escaping () -> Void) {
        self.title = title
        self.size = size
        self.colorType = colorType
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        
        Button {
            if !isDisabled {
                action()
            }
        } label: {
            Text(title)
                .font(size.fontStyle)
                .frame(maxWidth: size.maxWidth)
                .frame(width: size.width)
                .frame(height: size.height)
                .foregroundColor(currentStyle.foregroundColor)
                .background(currentStyle.backgroundColor)
                .clipShape(Capsule())
                .contentShape(Capsule())
                .overlay(
                        Capsule()
                            .stroke(currentStyle.borderColor, lineWidth: 1)
                    )
                
        }
        .buttonStyle(PressableButtonStyle(isPressed: $isPressed))
        .disabled(isDisabled)

    }
    
    private var currentStyle: CapsuleButtonStyle {
        CapsuleButtonStyle.style(for: colorType, isPressed: isPressed, isDisabled: isDisabled)
    }
}

// MARK: - CapsuleButtonSize
enum CapsuleButtonSize {
    
    case middle
    

    var height: CGFloat {
        switch self {
       
        case .middle:
            return 40
        }
    }

    var fontStyle: Font {
        switch self {
        case .middle:
            return Font.pretendard(.medium, size: 14)
      
        }
    }

    var width: CGFloat? {
        switch self {
        case .middle:
            return nil
        }
    }

    var maxWidth: CGFloat? {
        switch self {
        case .middle:
            return .infinity
        }
    }
}


// MARK: - CapsuleButtonStyle

struct CapsuleButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color

    static func style(for colorType: ButtonColorType, isPressed: Bool, isDisabled: Bool) -> CapsuleButtonStyle {
        switch (colorType, isDisabled, isPressed) {
        case (.fill, true, _):
            // Primary - Disabled
            return CapsuleButtonStyle(
                backgroundColor: .black100,
                foregroundColor: .white,
                borderColor: .clear
            )
        case (.fill, false, true):
            // Primary - Pressed
            return CapsuleButtonStyle(
                backgroundColor: .orange700,
                foregroundColor: .white,
                borderColor: .clear
            )
        case (.fill, false, false):
            // Primary - Normal
            return CapsuleButtonStyle(
                backgroundColor: .orange600,
                foregroundColor: .white,
                borderColor: .clear
            )
            
            
        case (.border, true, _):
            // Secondary - Disabled
            return CapsuleButtonStyle(
                backgroundColor: .white,
                foregroundColor: .black500,
                borderColor: .black100
            )
        case (.border, false, true):
            // Secondary - Pressed
            return CapsuleButtonStyle(
                backgroundColor: .orange50,
                foregroundColor: .black900,
                borderColor: .orange300
            )
        case (.border, false, false):
            // Secondary - Normal
            return CapsuleButtonStyle(
                backgroundColor: .white,
                foregroundColor: .black900,
                borderColor: .orange300
            )
        }
    }
}

#Preview {
    CapsuleButton(title: "버튼", colorType: .fill, isDisabled: false, action: {})
    CapsuleButton(title: "버튼", colorType: .border, isDisabled: false, action: {})
}
