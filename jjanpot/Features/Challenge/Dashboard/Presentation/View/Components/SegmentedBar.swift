//
//  SegmentedBar.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI

struct SegmentedBar: View {    
    let segments: [SegmentedBarViewData]
    let height: CGFloat = 18
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                ForEach(segments.indices, id: \.self) { index in
                    segments[index].color
                        .frame(width: geo.size.width * segments[index].ratio)
                }
            }
        }
        .background(Color.black100)
        .frame(height: height)
        .clipShape(Capsule())
        .overlay(
                Capsule()
                    .stroke(.white, lineWidth: 2)
            )
    }
}

#Preview {
    SegmentedBar(
        segments: [
            .init(ratio: 0.2, color: .red),
            .init(ratio: 0.25, color: .orange),
            .init(ratio: 0.15, color: .yellow),
            .init(ratio: 0.3, color: .brown),
            .init(ratio: 0.1, color: .black)
        ]
    )
    .padding(.horizontal, 20)
}
