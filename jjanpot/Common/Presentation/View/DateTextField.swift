//
//  DateTextField.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

struct DateTextField: View {
    
    let title: String
    let placeHolder: String
    @Binding var birthDate: Date?
    let isNeccessary: Bool
    
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
                    if let date = birthDate {
                        Text(date.toString(.dateOnly2))
                            .font(.pretendard(.regular, size: 14))
                            .foregroundStyle(Color.black900)
                    } else {
                        Text(placeHolder)
                            .font(.pretendard(.regular, size: 14))
                            .foregroundColor(.black200)
                    }
                    
                    Spacer()
                    Image("icon_calendar")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(Color.black800)
                    
                }
                .padding(.vertical, 14.5)
                .padding(.horizontal, 20)
                .roundedBorder(color: .black100, radius: 12)
                
                
            }
            
            
        }
    }
    
    
}



#Preview {
    DateTextField(
        title: "생일", placeHolder: "생년월일을 입력해 주세요.", birthDate: .constant(Date()), isNeccessary: true
    )
}
