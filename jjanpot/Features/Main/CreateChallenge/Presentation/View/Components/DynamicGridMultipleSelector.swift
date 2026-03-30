//
//  DynamicGridMultipleSelector.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import SwiftUI

/// 그리드 아이템으로 표시할 수 있는 프로토콜
protocol GridDisplayable: Identifiable, Hashable {
    var displayTitle: String { get }
    var displayImage: String? { get }
}


/// 배열을 받아서 그리드 형태로 다중 선택 UI를 제공하는 컴포넌트 (동적 데이터용)
struct DynamicGridMultipleSelector<T: GridDisplayable>: View {
    @Binding var selectedItems: [T]
    let items: [T]
    let columns: Int
    let maxSelection: Int?

    init(selectedItems: Binding<[T]>, items: [T], columns: Int = 3, maxSelection: Int? = nil) {
        self._selectedItems = selectedItems
        self.items = items
        self.columns = columns
        self.maxSelection = maxSelection
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 5), count: columns)
    }

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 5) {
            ForEach(items) { item in
                Button(action: { toggleSelection(item) }) {
                    HStack(alignment: .center, spacing: 4){
                        if let image = item.displayImage {
                            Image(image)
                                .resizable()
                                .frame(width: 14, height: 14)
                        }
                        Text(item.displayTitle)
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
        if let index = selectedItems.firstIndex(of: item) {
            selectedItems.remove(at: index)
        } else {
            // 최대 선택 개수 확인
            if let max = maxSelection, selectedItems.count >= max {
                return // 최대 개수 초과 시 선택 불가
            }
            selectedItems.append(item)
        }
    }
}

#Preview {
    struct SampleItem: GridDisplayable {
        let id: Int
        let name: String

        var displayTitle: String { name }
        var displayImage: String? { nil }

        static func == (lhs: SampleItem, rhs: SampleItem) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    struct PreviewWrapper: View {
        @State var selected: [SampleItem] = []

        let items = [
            SampleItem(id: 1, name: "항목 1"),
            SampleItem(id: 2, name: "항목 2"),
            SampleItem(id: 3, name: "항목 3"),
            SampleItem(id: 4, name: "항목 4"),
            SampleItem(id: 5, name: "항목 5")
        ]

        var body: some View {
            VStack(spacing: 20) {
                Text("동적 다중 선택 (최대 3개)")
                    .font(.headline)

                Text("선택됨: \(selected.count)개")
                    .font(.caption)

                DynamicGridMultipleSelector(
                    selectedItems: $selected,
                    items: items,
                    maxSelection: 3
                )
                .padding()
            }
        }
    }

    return PreviewWrapper()
}
