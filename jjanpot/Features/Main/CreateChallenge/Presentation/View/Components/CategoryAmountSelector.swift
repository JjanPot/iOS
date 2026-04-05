//
//  CategoryAmountSelector.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import SwiftUI

struct CategoryAmountSelector: View {
    let category: SavingCategoryViewData
    @Binding var selectedAmount: Int?

    private let gridColumns = [GridItem(.flexible(), spacing: 5),
                               GridItem(.flexible(), spacing: 5),
                               GridItem(.flexible(), spacing: 5)]
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("\(category.displayTitle) | 1회 기준 금액을 얼마로 정하시겠어요?\n(이 금액을 기준으로 절약액을 계산해요.)")
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(Color.black500)
            
            
            // 금액 옵션 그리드
            LazyVGrid(columns: gridColumns, spacing: 5) {
                ForEach(category.amountOptions, id: \.self) { amount in
                    AmountOptionButton(
                        amount: amount,
                        isSelected: selectedAmount == amount
                    ) {
                        selectedAmount = amount
                    }
                }
            }
        }
//        .padding(.vertical, 16)
//        .padding(.horizontal, 20)
//        .background(Color.orange50)
        .rounded(radius: 8)
    }
}

struct AmountOptionButton: View {
    let amount: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(amount)원")
                .font(.pretendard(.medium, size: 12))
                .frame(maxWidth: .infinity)
                .frame(height: 37)
                .foregroundColor(.black900)
                .background(Color.white)
                .roundedBorder(
                    color: isSelected ? .orange500 : .black100,
                    radius: 8
                )
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var selectedAmount: Int? = 15000

        var body: some View {
            CategoryAmountSelector(
                category: SavingCategoryViewData(
                    id: 1,
                    name: "외식/배달",
                    nameUS: "FOOD_DELIVERY",
                    iconName: "icon_category_food",
                    amountOptions: [10000, 15000, 20000, 30000]
                ),
                selectedAmount: $selectedAmount
            )
            .padding()
        }
    }

    return PreviewWrapper()
}
