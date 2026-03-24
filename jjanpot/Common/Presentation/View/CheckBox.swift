//
//  CheckBox.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import SwiftUI

// MARK: - 단일 체크박스

struct CheckBox: View {
    @Binding var isChecked: Bool
    var text: String
    var color: Color = .orange500
    var size: CGFloat = 24
    var font: Font = .body
    var textColor: Color = .black600
    var buttonText: String? = nil
    var buttonAction: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 8) {
            // 체크박스 이미지 + 텍스트 (토글 영역)
            Button(action: {
                isChecked.toggle()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: size, height: size)
                        .foregroundColor(isChecked ? color : .black300)

                    Text(text)
                        .font(font)
                        .foregroundColor(textColor)
                }
            }
            .buttonStyle(PlainButtonStyle())

            Spacer()

            // 옵셔널 버튼
            if let buttonText = buttonText, let buttonAction = buttonAction {
                Button(action: buttonAction) {
                    Text(buttonText)
                        .font(.pretendard(.regular, size: 10))
                        .foregroundColor(.black600)
                }
            }
        }
    }
}

// MARK: - 체크박스 그룹

struct CheckBoxGroup: View {
    @Binding var allChecked: Bool
    @Binding var items: [Bool]
    var color: Color = .orange500
    var size: CGFloat = 18
    var allLabel: String
    var allButtonText: String? = nil
    var allButtonAction: (() -> Void)? = nil
    var itemLabels: [String]
    var itemButtonTexts: [String?] = []
    var itemButtonActions: [(() -> Void)?] = []

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            // 전체 선택 체크박스
            CheckBox(
                isChecked: Binding(
                    get: { items.allSatisfy { $0 } && !items.isEmpty },
                    set: { newValue in
                        items = items.map { _ in newValue }
                        allChecked = newValue
                    }
                ),
                text: allLabel,
                color: color,
                size: size,
                font: .pretendard(.semiBold, size: 16),
                textColor: .black900,
                buttonText: allButtonText,
                buttonAction: allButtonAction
            )
            .onChange(of: items) { newValue in
                allChecked = newValue.allSatisfy { $0 } && !newValue.isEmpty
            }
            
            Divider()
                .padding(.top, 8)
                .padding(.bottom, 25)

            // 하위 체크박스들
            VStack(alignment: .leading, spacing: 24) {
                ForEach(items.indices, id: \.self) { index in
                    CheckBox(
                        isChecked: $items[index],
                        text: itemLabels[index],
                        color: color,
                        size: size,
                        font: .pretendard(.medium, size: 14),
                        buttonText: itemButtonTexts.indices.contains(index) ? itemButtonTexts[index] : nil,
                        buttonAction: itemButtonActions.indices.contains(index) ? itemButtonActions[index] : nil
                    )
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 40) {
        // 단일 체크박스 예시 (버튼 없음)
        CheckBox(
            isChecked: .constant(true),
            text: "버튼 없는 체크박스",
            color: .orange500
        )

        // 단일 체크박스 예시 (버튼 있음)
        CheckBox(
            isChecked: .constant(false),
            text: "버튼 있는 체크박스",
            color: .orange500,
            buttonText: "상세보기",
            buttonAction: { print("버튼 클릭") }
        )

        Divider()

        // 체크박스 그룹 예시
        CheckBoxGroupExample()
    }
    .padding()
}

struct CheckBoxGroupExample: View {
    @State private var allChecked = false
    @State private var items = [false, false, false]

    var body: some View {
        CheckBoxGroup(
            allChecked: $allChecked,
            items: $items,
            color: .orange500,
            allLabel: "전체 동의",
            itemLabels: [
                "필수 이용약관 동의",
                "개인정보 수집 및 이용 동의",
                "마케팅 정보 수신 동의"
            ],
            itemButtonTexts: ["보기", "보기", nil],
            itemButtonActions: [
                { print("이용약관 보기") },
                { print("개인정보 보기") },
                nil
            ]
        )
    }
}
