//
//  LoadingModifier.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//

import Foundation
import SwiftUI

// MARK: - 로딩 뷰 코드 간소화

struct LoadingModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                ProgressView()
                    .tint(.orange600)
                    .scaleEffect(1.5)
            }
        }
    }
}

extension View {
    func loading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
}

