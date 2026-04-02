//
//  MainButton.swift
//  jjanpot
//
//  Created by 임주희 on 3/24/26.
//

import SwiftUI


enum ModalButtonColorType {
    case primary
    case secondary
}

enum ModalButtonSize {
    case large
    case middle
    case small

    var height: CGFloat {
        switch self {
        case .large:
            return 48
        case .middle:
            return 47
        case .small:
            return 42
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
            return 12
        case .small:
            return 8
        }
    }

    var width: CGFloat? {
        switch self {
        case .large:
            return nil
            
        case .middle:
            return nil
            
        case .small:
            return 100
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


struct ModalButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color

    static func style(for colorType: ModalButtonColorType, isPressed: Bool, isDisabled: Bool) -> ModalButtonStyle {
        switch (colorType, isDisabled, isPressed) {
        case (.primary, true, _):
            // Primary - Disabled
            return ModalButtonStyle(
                backgroundColor: .black100,
                foregroundColor: .white,
                borderColor: .clear
            )
        case (.primary, false, true):
            // Primary - Pressed
            return ModalButtonStyle(
                backgroundColor: .orange700,
                foregroundColor: .white,
                borderColor: .clear
            )
        case (.primary, false, false):
            // Primary - Normal
            return ModalButtonStyle(
                backgroundColor: .orange500,
                foregroundColor: .white,
                borderColor: .clear
            )
            
            
        case (.secondary, true, _):
            // Secondary - Disabled
            return ModalButtonStyle(
                backgroundColor: .white,
                foregroundColor: .black500,
                borderColor: .black100
            )
        case (.secondary, false, true):
            // Secondary - Pressed
            return ModalButtonStyle(
                backgroundColor: .black200,
                foregroundColor: .black500,
                borderColor: .clear
            )
        case (.secondary, false, false):
            // Secondary - Normal
            return ModalButtonStyle(
                backgroundColor: .black100,
                foregroundColor: .black500,
                borderColor: .clear
            )
        }
    }
}
// MARK: - MainButton
struct ModalButton: View {
    let title: String
    let size: ModalButtonSize
    let colorType: ModalButtonColorType
    let isDisabled: Bool
    let action: () -> Void

    @State private var isPressed: Bool = false

    init(
        title: String,
        size: ModalButtonSize = .large,
        colorType: ModalButtonColorType = .primary,
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

    private var currentStyle: ModalButtonStyle {
        ModalButtonStyle.style(for: colorType, isPressed: isPressed, isDisabled: isDisabled)
    }
}

//struct PressableButtonStyle: ButtonStyle {
//    @Binding var isPressed: Bool
//
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .onChange(of: configuration.isPressed) { newValue in
//                isPressed = newValue
//            }
//    }
//}

#Preview {
    VStack(spacing: 20) {
        // Large
        ModalButton(title: "Large Primary", size: .large, colorType: .primary) {
            print("Tapped")
        }
        ModalButton(title: "Large Primary", size: .large, colorType: .primary, isDisabled: true) {
            print("Tapped")
        }

        ModalButton(title: "Large Secondary", size: .large, colorType: .secondary) {
            print("Tapped")
        }

        ModalButton(title: "Large Disabled", size: .large, colorType: .secondary, isDisabled: true) {
            print("Tapped")
        }

        // Middle
        ModalButton(title: "Middle Primary", size: .middle, colorType: .primary) {
            print("Tapped")
        }
        ModalButton(title: "Middle Secondary", size: .middle, colorType: .secondary, isDisabled: true) {
            print("Tapped")
        }


        ModalButton(title: "Middle Secondary", size: .middle, colorType: .secondary) {
            print("Tapped")
        }
        ModalButton(title: "Middle Secondary", size: .middle, colorType: .secondary, isDisabled: true) {
            print("Tapped")
        }
       
        // Small
        ModalButton(title: "버튼", size: .small, colorType: .primary) {
            print("Tapped")
        }
        ModalButton(title: "버튼", size: .small, colorType: .primary, isDisabled: true) {
            print("Tapped")
        }

        ModalButton(title: "버튼", size: .small, colorType: .secondary) {
            print("Tapped")
        }
        ModalButton(title: "버튼", size: .small, colorType: .secondary, isDisabled: true) {
            print("Tapped")
        }
    }
}
