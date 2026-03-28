//
//  GridMultipleSelector.swift
//  jjanpot
//
//  Created by 임주희 on 3/28/26.
//


import SwiftUI

/// enum을 받아서 그리드 형태로 다중 선택 UI를 제공하는 공통 컴포넌트
struct GridMultipleSelector<T: SelectableGridItem>: View {
    @Binding var selectedItems: Set<T>
    let columns: Int
    let maxSelection: Int?

    init(selectedItems: Binding<Set<T>>, columns: Int = 3, maxSelection: Int? = nil) {
        self._selectedItems = selectedItems
        self.columns = columns
        self.maxSelection = maxSelection
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 5), count: columns)
    }

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 5) {
            ForEach(Array(T.allCases), id: \.self) { item in
                Button(action: { toggleSelection(item) }) {
                    HStack(alignment: .center, spacing: 4){
                        if let image = item.image {
                            Image(image)
                                .resizable()
                                .frame(width: 14, height: 14)
                        }
                        Text(item.title)
                            .font(.pretendard(.medium, size: 12))
                            .foregroundColor(.black900)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 37)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedItems.contains(item) ? Color.orange500 : Color.black100, lineWidth: 1)
                    )
                }
            }
        }
    }

    private func toggleSelection(_ item: T) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            // 최대 선택 개수 확인
            if let max = maxSelection, selectedItems.count >= max {
                return // 최대 개수 초과 시 선택 불가
            }
            selectedItems.insert(item)
        }
    }
}

#Preview("Multiple Selector") {

    return SampleGridMultipleSelector()
}

struct SampleGridMultipleSelector : View {
    enum SampleType: SelectableGridItem {
        var image: String? {
            switch self{
            case .option1: "icon_category_bear"
            default: nil
            }
        }
        
        case option1
        case option2
        case option3
        case option4

        var title: String {
            switch self {
            case .option1: return "옵션 1"
            case .option2: return "옵션 2"
            case .option3: return "옵션 3"
            case .option4: return "옵션 4"
            }
        }
    }
    
    @State var selected: Set<SampleType> = .init()
    var body: some View {
        VStack(spacing: 20) {
            Text("다중 선택 (최대 2개)")
                .font(.headline)

            Text("선택됨: \(selected.count)개")
                .font(.caption)

            GridMultipleSelector<SampleType>(selectedItems: $selected, maxSelection: 2)
                .padding()
        }
    }
}
