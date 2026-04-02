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
        .background(Color.white)
        .frame(height: height)
        .clipShape(Capsule())
        .overlay(
                Capsule()
                    .stroke(.white, lineWidth: 4)
            )
        .overlay(
                Capsule()
                    .stroke(.orange400, lineWidth: 1)
            )
    }
}

#Preview {
    SegmentedBar(
        segments: [
            .init(ratio: 0.125, color: ColorPalette.chartColors[0]),
            .init(ratio: 0.125, color: ColorPalette.chartColors[1]),
            .init(ratio: 0.125, color: ColorPalette.chartColors[2]),
            .init(ratio: 0.125, color: ColorPalette.chartColors[3]),
            .init(ratio: 0.125, color: ColorPalette.chartColors[4]),
            .init(ratio: 0.125, color: ColorPalette.chartColors[5]),
            .init(ratio: 0.125, color: ColorPalette.chartColors[6]),
            .init(ratio: 0.125, color: ColorPalette.chartColors[7]),
        ]
    )
    .padding(.horizontal, 20)
}
