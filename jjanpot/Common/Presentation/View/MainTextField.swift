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
    @Binding var errorMessage: String?
    let keyboardType: UIKeyboardType
    
    init(title: String, placeHolder: String, textValue: Binding<String>, isNeccessary: Bool, textLimit: Int?, errorMessage: Binding<String?>, keyboardType: UIKeyboardType = .default) {
        self.title = title
        self.placeHolder = placeHolder
        self._textValue = textValue
        self.isNeccessary = isNeccessary
        self.textLimit = textLimit
        self._errorMessage = errorMessage
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(spacing: .zero) {
                Text(title)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(Color.black600)
                
                if isNeccessary {
                    Text("*")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(Color.red500)
                }
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    TextField("", text: $textValue,
                              prompt: Text(placeHolder)
                        .font(.pretendard(.regular, size: 14))
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
                
                if let msg = errorMessage {
                    Text(msg)
                        .font(.pretendard(.regular, size: 14))
                        .foregroundStyle(Color.orange500)
                        .padding(.leading,2)
                    
                }
                
            }
            
            
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
        errorMessage: .constant("유효하지 않습니다."),
        keyboardType: .numberPad)
}
