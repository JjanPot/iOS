//
//  View+Extension.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import Foundation
import SwiftUI

extension View {
    
    func roundedBorder(color: Color, radius: CGFloat, lineWidth: CGFloat = 1) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: lineWidth)
        )
    }
    
    
    func rounded(radius: CGFloat) -> some View {
        self.clipShape(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                
        )
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }

}


// MARK: - 로딩 뷰 코드 간소화

struct LoadingModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                ProgressView()
                    .tint(.orange500)
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



extension View {
    func hideTabBar() -> some View {
        self.onAppear {
            // 탭바 숨기기
            UITabBar.appearance().isHidden = true
            
            // 투명하게 설정
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

