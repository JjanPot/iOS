//
//  PriceSliderView.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//

import SwiftUI

struct PriceSliderView: View {
    @State var priceString: String = ""
    @Binding var price: Double
    
    let minPrice: Double
    let maxPrice: Double
    let step: Double
    let placeholder: String
    
    @FocusState private var isTextFieldFocused: Bool
    
    init(
        price: Binding<Double>,
        minPrice: Double,
        maxPrice: Double,
        step: Double = 1000,
        placeholder: String = "금액 입력"
    ) {
        self._price = price
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.step = step
        self.placeholder = placeholder
        self._priceString = State(initialValue: "\(Int(price.wrappedValue))")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack (alignment: .bottom, spacing: 8) {
                
                TextField("", text: $priceString, prompt:
                            Text(placeholder)
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color.black200)
                )
                .keyboardType(.numberPad)
                .font(.pretendard(.regular, size: 14))
                .foregroundColor(Color.black900)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(width: 120)
                .roundedBorder(color: .black100, radius: 12)
                .focused($isTextFieldFocused)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("완료") {
                            validateAndSync()
                            isTextFieldFocused = false
                        }
                        .foregroundStyle(.orange500)
                    }
                }
                .onChange(of: priceString) { newValue in
                    // 타이핑 중에도 유효한 값이면 실시간 반영
                    if let value = Double(newValue), value >= minPrice, value <= maxPrice {
                        price = value
                    }
                }
                .overlay(alignment: .trailing) {
                    Text("원")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color.black900)
                        .padding(.trailing, 20)
                        .allowsHitTesting(false)
                }
                
                Text("\(formatPrice(price))")
                    .font(.pretendard(.medium, size: 12))
                    .foregroundStyle(Color.black500)
                    .padding(.bottom, 8)
            }
            
            
            VStack(spacing: 5) {
                Slider(
                    value: $price,
                    in: minPrice...maxPrice,
                    step: step
                )
                .tint(Color.orange500)
                .onChange(of: price) { newValue in
                    // Slider 조정 시 TextField에 반영
                    priceString = "\(Int(newValue))"
                }
                
                HStack {
                    Text(formatPrice(minPrice))
                        .font(.pretendard(.medium, size: 12))
                    Spacer()
                    Text(formatPrice(maxPrice))
                        .font(.pretendard(.medium, size: 12))
                }
                .foregroundStyle(Color.black500)
            }
        }
    }
    
    private func validateAndSync() {
        guard let value = Double(priceString) else {
            // 잘못된 입력이면 원래 값으로 복원
            priceString = "\(Int(price))"
            return
        }
        
        if value >= minPrice, value <= maxPrice { // 범위 안의 값
            price = value
            priceString = "\(Int(value))"
        } else if value < minPrice {
            price = minPrice
            priceString = "\(Int(price))"
        } else if value > maxPrice {
            price = maxPrice
            priceString = "\(Int(price))"
        } else {
            // 잘못된 입력이면 원래 값으로 복원
            priceString = "\(Int(price))"
        }
    }
    
    private func formatPrice(_ value: Double) -> String {
        let intValue = Int(value)
        
        let manValue = intValue / 10000  // 만 단위
        let cheonValue = (intValue % 10000) / 1000  // 천 단위
        
        var result = ""
        
        if manValue > 0 {
            result += "\(manValue)만"
        }
        
        if cheonValue > 0 {
            result += "\(cheonValue)천"
        }
        
        if result.isEmpty {
            return "\(intValue)원"
        }
        
        return result + "원"
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var price: Double = 50000
        
        var body: some View {
            VStack(spacing: 20) {
                Text("현재 금액: \(Int(price))원")
                    .padding()
                
                PriceSliderView(
                    price: $price,
                    minPrice: 5000,
                    maxPrice: 3000000,
                    step: 1000,
                    placeholder: "목표 금액"
                )
                .padding()
            }
        }
    }
    
    return PreviewWrapper()
}
