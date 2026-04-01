//
//  CategorySelector.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI


struct CategorySelectorViewData: Identifiable {
    //categoryId
    let id: Int
    let name: String
    let icon: String
    // 기준금액
    let amount: Int
}
struct CategorySelector: View {
    
    @Binding var selected: CategorySelectorViewData?
    let categories: [CategorySelectorViewData]
    
    private let gridColumns = [GridItem(.flexible(), spacing: 7),
                               GridItem(.flexible(), spacing: 7),
                               GridItem(.flexible(), spacing: 7),
    ]
    
    var body: some View {
        LazyVGrid(columns: gridColumns) {
            ForEach(categories) { category in
                Button {
                    selected = category
                } label: {
                    VStack(alignment: .center, spacing: 4) {
                        Image(category.icon)
                            .resizable()
                            .frame(width: 28, height: 28)
                        
                        Text(category.name)
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(.black900)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 88)
                    .roundedBorder(color: (selected?.id == category.id) ? .orange500 : .black100, radius: 12)
                }
            }
        }
    }
}


#Preview {
    CategorySelector(
        selected: .constant(nil),
        categories: [
            .init(id: 0, name: "카페/디저트", icon: "icon_category_cafe", amount: 10000),
            .init(id: 1, name: "교통", icon: "icon_category_cafe", amount: 15000),
            .init(id: 2, name: "패션/뷰티", icon: "icon_category_car", amount: 20000),
        ])
}

