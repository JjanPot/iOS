//
//  MemberSliderView.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//

import SwiftUI

struct MemberSliderView<FocusField: Hashable>: View {
    @State var memberCountString: String = ""
    @State private var wasFocused: Bool = false
    @Binding var memberCount: Double
    @FocusState.Binding var focusedField: FocusField?
    let fieldIdentifier: FocusField
    var onEndEditing: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("", text: $memberCountString, prompt:
                        Text("최대 8")
                .font(.pretendard(.regular, size: 14))
                .foregroundColor(Color.black200)
            )
            .keyboardType(.numberPad)
            .font(.pretendard(.regular, size: 14))
            .foregroundColor(Color.black900)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(width: 100)
            .roundedBorder(color: .black100, radius: 12)
            .focused($focusedField, equals: fieldIdentifier)
            .onChange(of: memberCountString) { newValue in
                // 타이핑 중에도 유효한 값이면 실시간 반영
                if let value = Double(newValue), value >= 2, value <= 8 {
                    memberCount = value
                }
            }
            .onChange(of: focusedField) { newValue in
                let isFocusedNow = (newValue == fieldIdentifier)

                // 이 필드가 포커스를 잃었을 때만 실행
                if wasFocused && !isFocusedNow {
                    validateAndSync()
                    onEndEditing?()
                }

                wasFocused = isFocusedNow
            }
            .overlay(alignment: .trailing) {
                Text("명")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black900)
                    .padding(.trailing, 20)
                    .allowsHitTesting(false)
            }

            VStack(spacing: 5) {
                Slider(
                    value: $memberCount,
                    in: 2...8,
                    step: 1
                )
                .tint(Color.orange500)
                .onChange(of: memberCount) { newValue in
                    // Slider 조정 시 TextField에 반영
                    memberCountString = "\(Int(newValue))"
                }

                HStack {
                    Text("2")
                        .font(.pretendard(.medium, size: 12))
                    Spacer()
                    Text("8")
                        .font(.pretendard(.medium, size: 12))
                }
                .foregroundStyle(Color.black500)
            }
        }
    }

    func validateAndSync() {
        guard let value = Double(memberCountString) else {
            // 잘못된 입력이면 원래 값으로 복원
            memberCountString = "\(Int(memberCount))"
            return
        }
        
        
        if  value >= 2, value <= 8 { // 범위 안의 값
            memberCount = value
            memberCountString = "\(Int(value))"
        } else if value < 2 {
            memberCount = 2
            memberCountString = "\(Int(memberCount))"
        } else if value > 8 {
            memberCount = 8
            memberCountString = "\(Int(memberCount))"
        }else {
            // 잘못된 입력이면 원래 값으로 복원
            memberCountString = "\(Int(memberCount))"
        }
    }
}

#Preview {
    enum PreviewField {
        case member
    }

    struct PreviewWrapper: View {
        @State var memberCount: Double = 2.0
        @FocusState var focusedField: PreviewField?

        var body: some View {
            VStack {
                Text("현재 인원: \(Int(memberCount))명")
                    .padding()

                MemberSliderView(
                    memberCount: $memberCount,
                    focusedField: $focusedField,
                    fieldIdentifier: .member
                )
                .padding()
            }
        }
    }

    return PreviewWrapper()
}
