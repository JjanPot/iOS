//
//  CategorySelector.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI


struct CategorySelectorViewData: Identifiable {
    let id: UUID = UUID()
    let title: String
    let icon: String
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
                        
                        Text(category.title)
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(.black900)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 88)
                    .roundedBorder(color: (selected?.title == category.title) ? .orange500 : .black100, radius: 12)
                }
            }
        }
    }
}


#Preview {
    CategorySelector(
        selected: .constant(nil),
        categories: [
            .init(title: "카페/디저트", icon: "icon_category_cafe"),
            .init(title: "교통", icon: "icon_category_car"),
            .init(title: "패션/뷰티", icon: "icon_category_car"),
        ])
}
