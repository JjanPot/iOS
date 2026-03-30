//
//  GridSingleSeletor.swift
//  jjanpot
//
//  Created by 임주희 on 3/28/26.
//

import SwiftUI

// MARK: - Protocol
/// GridSingleSelector, GridMultipleSelector 에서 사용할 enum이 준수해야 하는 프로토콜
protocol SelectableGridItem: CaseIterable, Hashable {
    var title: String { get }
    var image: String? { get }
}

// MARK: - GridSingleSelector
/// enum을 받아서 그리드 형태로 단일 선택 UI를 제공하는 공통 컴포넌트
struct GridSingleSelector<T: SelectableGridItem>: View {
    @Binding var selectedItem: T?
    let columns: Int

    init(selectedItem: Binding<T?>, columns: Int = 3) {
        self._selectedItem = selectedItem
        self.columns = columns
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 5), count: columns)
    }

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 5) {
            ForEach(Array(T.allCases), id: \.self) { item in
                Button(action: { selectedItem = item }) {
                    Text(item.title)
                        .font(.pretendard(.medium, size: 12))
                        .frame(maxWidth: .infinity)
                        .frame(height: 37)
                        .foregroundColor(.black900)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selectedItem == item ? Color.orange500 : Color.black100, lineWidth: 1)
                        )
                }
            }
        }
    }
}

#Preview("Single Selector") {
    return SampleGridSingleSelector()
}

struct SampleGridSingleSelector : View {
    enum SampleType: SelectableGridItem {
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

        var image: String? {
            return nil
        }
    }

    @State var selected: SampleType?
    var body: some View {
        VStack(spacing: 20) {
            Text("단일 선택")
                .font(.headline)

            GridSingleSelector<SampleType>(selectedItem: $selected)
                .padding()
        }
    }
}
