//
//  SavingCategoryDetail.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//

import SwiftUI

struct SavingCategoryDetail: View {
    let category: SavingCategory

    @Binding var selectedFoodAmount: FoodEstimatedSavingAmount?
    @Binding var selectedCafeAmount: CafeEstimatedSavingAmount?
    @Binding var selectedCarAmount: CarEstimatedSavingAmount?
    @Binding var selectedFashionAmount: FashionEstimatedSavingAmount?
    @Binding var selectedHobbyAmount: HobbyEstimatedSavingAmount?
    @Binding var selectedBearAmount: BearEstimatedSavingAmount?
    @Binding var selectedOtherAmount: OtherEstimatedSavingAmount?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(category.title) | 한 번 구매할 때 얼마나 쓰시나요?\n(이 금액을 기준으로 절약액을 계산해요.)")
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(Color.black500)

            amountSelector
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color.orange50)
        .rounded(radius: 12)
    }

    @ViewBuilder
    private var amountSelector: some View {
        switch category {
        case .food:
            GridSingleSelector(selectedItem: $selectedFoodAmount, columns: 3)
        case .cafe:
            GridSingleSelector(selectedItem: $selectedCafeAmount, columns: 3)
        case .car:
            GridSingleSelector(selectedItem: $selectedCarAmount, columns: 3)
        case .fasion:
            GridSingleSelector(selectedItem: $selectedFashionAmount, columns: 3)
        case .hobby:
            GridSingleSelector(selectedItem: $selectedHobbyAmount, columns: 3)
        case .bear:
            GridSingleSelector(selectedItem: $selectedBearAmount, columns: 3)
        case .other:
            GridSingleSelector(selectedItem: $selectedOtherAmount, columns: 3)
        }
    }
}
