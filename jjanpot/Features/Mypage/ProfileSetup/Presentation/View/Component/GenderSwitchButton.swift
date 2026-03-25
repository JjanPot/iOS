//
//  GenderSwitchButton.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

enum Gender {
    case man
    case woman
    
    var name: String {
        switch self {
        case .man: return "남성"
        case .woman: return "여성"
        }
    }
}
struct GenderSwitchButton: View {
    
    
    var body: some View {
        HStack {
            

        }
    }
}

#Preview {
    GenderSwitchButton()
}
