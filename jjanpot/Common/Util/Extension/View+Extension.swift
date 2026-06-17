//
//  View+Extension.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import Foundation
import SwiftUI
import UIKit

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
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(
            RoundedCorner(radius: radius, corners: corners)
        )
    }
}


// MARK: - Custom Shape for Specific Corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
