//
//  CustomDisclosureGroup.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//

import SwiftUI

struct CustomDisclosureGroup<Label: View, Content: View>: View {
    @Binding private var isExpanded: Bool

    private let label: () -> Label
    private let content: () -> Content

    @State private var contentHeight: CGFloat = 0

    init(
        isExpanded: Binding<Bool>,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isExpanded = isExpanded
        self.label = label
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            ZStack(alignment: .top) {
                content()
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    contentHeight = proxy.size.height
                                }
                        }
                    )
                    .opacity(isExpanded ? 1 : 0)
            }
            .frame(height: isExpanded ? contentHeight : 0)
            .clipped()
            .animation(.easeInOut(duration: 0.25), value: isExpanded)
        }
    }

    private var header: some View {
        HStack {
            label()
            Spacer()
            Image(systemName: "chevron.down")
                .rotationEffect(.degrees(isExpanded ? -180 : 0))
                .animation(.easeInOut(duration: 0.2), value: isExpanded)
                .foregroundStyle(.black600)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}
