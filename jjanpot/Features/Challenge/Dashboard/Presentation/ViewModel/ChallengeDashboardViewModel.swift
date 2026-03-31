//
//  ChallengeDashboardViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


import SwiftUI
import Combine
final class ChallengeDashboardViewModel: ObservableObject {
    
    
    @Published var members: [MemberCardViewData] = [
        .init(imageUrl: "https://picsum.photos/50/50",
              color: .red,
              name: "닉네임",
              amount: 10000),
        .init(imageUrl: "https://picsum.photos/50/50",
              color: .blue,
              name: "닉네임",
              amount: 10000),
        .init(imageUrl: "https://picsum.photos/50/50",
              color: .yellow,
              name: "닉네임",
              amount: 10000),
        .init(imageUrl: "https://picsum.photos/50/50",
              color: .green,
              name: "닉네임",
              amount: 10000),
    ]
    
    
    @Published var isLoading = false
    @Published var toastMessage: String?
    
    private let useCase: ChallengeDashboardUseCaseProtocol
    init(useCase: ChallengeDashboardUseCaseProtocol) {
        self.useCase = useCase
    }
}



