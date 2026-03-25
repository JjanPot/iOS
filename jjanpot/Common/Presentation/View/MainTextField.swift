//
//  MainTextField.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI
import UIKit

struct MainTextField: View {
    
    let title: String
    let placeHolder: String
    @Binding var textValue: String
    let isNeccessary: Bool
    let textLimit: Int?
    let keyboardType: UIKeyboardType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(spacing: .zero) {
                Text(title)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(Color.black600)
                
                if isNeccessary {
                    Text("*")
                        .font(.pretendard(.semiBold, size: 14))
                }
                
            }
            
            HStack {
                TextField("", text: $textValue,
                          prompt: Text(placeHolder)
                              .foregroundColor(.black200)
                )
                .keyboardType(keyboardType)
                .onChange(of: textValue) { newValue in
                    if let limitCount = textLimit,
                       newValue.count > limitCount {
                        textValue = String(newValue.prefix(limitCount))
                    }
                }
                
                if let limit = textLimit {
                    Text("\(textValue.count)/\(limit)")
                        .foregroundStyle(Color.black200)
                }
            }
            .padding(.vertical, 14.5)
            .padding(.horizontal, 20)
            .roundedBorder(color: .black100, radius: 12)
            
            
        }
    }
}

#Preview {
    MainTextField(
        title: "초대코드",
        placeHolder: "초대 코드를 입력해주세요",
        textValue: .constant(""),
        isNeccessary: true,
        textLimit: 10,
        keyboardType: .numberPad)
}
