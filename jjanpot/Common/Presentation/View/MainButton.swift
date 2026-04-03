//
//  MainButton.swift
//  jjanpot
//
//  Created by 임주희 on 3/24/26.
//

import SwiftUI


enum ButtonColorType {
    case fill
    case border
}

enum MainButtonSize {
    case large
    case middle
    case small

    var height: CGFloat {
        switch self {
        case .large:
            return 48
        case .middle:
            return 42
        case .small:
            return 37
        }
    }

    var fontStyle: Font {
        switch self {
        case .large:
            return Font.pretendard(.medium, size: 16)
        case .middle:
            return Font.pretendard(.medium, size: 16)
        case .small:
            return Font.pretendard(.medium, size: 12)
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .large:
            return 12
        case .middle:
            return 10
        case .small:
            return 8
        }
    }

    var width: CGFloat? {
        switch self {
        case .large:
            return nil
            
        case .middle:
            return 173
            
        case .small:
            return 103
        }
    }

    var maxWidth: CGFloat? {
        switch self {
        case .large, .middle:
            return .infinity
        case .small:
            return nil
        }
    }
}


struct MainButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color

    static func style(for colorType: ButtonColorType, isPressed: Bool, isDisabled: Bool) -> MainButtonStyle {
        switch (colorType, isDisabled, isPressed) {
        case (.fill, true, _):
            // Primary - Disabled
            return MainButtonStyle(
                backgroundColor: .black100,
                foregroundColor: .white,
                borderColor: .clear
            )
        case (.fill, false, true):
            // Primary - Pressed
            return MainButtonStyle(
                backgroundColor: .orange700,
                foregroundColor: .white,
                borderColor: .clear
            )
        case (.fill, false, false):
            // Primary - Normal
            return MainButtonStyle(
                backgroundColor: .orange500,
                foregroundColor: .white,
                borderColor: .clear
            )
            
            
        case (.border, true, _):
            // Secondary - Disabled
            return MainButtonStyle(
                backgroundColor: .white,
                foregroundColor: .black500,
                borderColor: .black100
            )
        case (.border, false, true):
            // Secondary - Pressed
            return MainButtonStyle(
                backgroundColor: .orange50,
                foregroundColor: .black500,
                borderColor: .orange500
            )
        case (.border, false, false):
            // Secondary - Normal
            return MainButtonStyle(
                backgroundColor: .white,
                foregroundColor: .black900,
                borderColor: .orange500
            )
        }
    }
}
// MARK: - MainButton
struct MainButton: View {
    let title: String
    let size: MainButtonSize
    let colorType: ButtonColorType
    let isDisabled: Bool
    let action: () -> Void

    @State private var isPressed: Bool = false

    init(
        title: String,
        size: MainButtonSize = .large,
        colorType: ButtonColorType = .fill,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.size = size
        self.colorType = colorType
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: {
            if !isDisabled {
                action()
            }
        }) {
            Text(title)
                .font(size.fontStyle)
                .frame(maxWidth: size.maxWidth)
                .frame(width: size.width)
                .frame(height: size.height)
                .foregroundColor(currentStyle.foregroundColor)
                .background(currentStyle.backgroundColor)
                .contentShape(RoundedRectangle(cornerRadius: size.cornerRadius))
                .cornerRadius(size.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .stroke(currentStyle.borderColor, lineWidth: 1)
                )
        }
        .buttonStyle(PressableButtonStyle(isPressed: $isPressed))
        .disabled(isDisabled)
    }

    private var currentStyle: MainButtonStyle {
        MainButtonStyle.style(for: colorType, isPressed: isPressed, isDisabled: isDisabled)
    }
}

struct PressableButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { newValue in
                isPressed = newValue
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Large
        MainButton(title: "Large Primary", size: .large, colorType: .fill) {
            print("Tapped")
        }
        MainButton(title: "Large Primary", size: .large, colorType: .fill, isDisabled: true) {
            print("Tapped")
        }

        MainButton(title: "Large Secondary", size: .large, colorType: .border) {
            print("Tapped")
        }

        MainButton(title: "Large Disabled", size: .large, colorType: .border, isDisabled: true) {
            print("Tapped")
        }

        // Middle
        MainButton(title: "Middle Primary", size: .middle, colorType: .fill) {
            print("Tapped")
        }
        MainButton(title: "Middle Secondary", size: .middle, colorType: .border, isDisabled: true) {
            print("Tapped")
        }


        MainButton(title: "Middle Secondary", size: .middle, colorType: .border) {
            print("Tapped")
        }
        MainButton(title: "Middle Secondary", size: .middle, colorType: .border, isDisabled: true) {
            print("Tapped")
        }
       
        // Small
        MainButton(title: "버튼", size: .small, colorType: .fill) {
            print("Tapped")
        }
        MainButton(title: "버튼", size: .small, colorType: .fill, isDisabled: true) {
            print("Tapped")
        }

        MainButton(title: "버튼", size: .small, colorType: .border) {
            print("Tapped")
        }
        MainButton(title: "버튼", size: .small, colorType: .border, isDisabled: true) {
            print("Tapped")
        }
    }
}
