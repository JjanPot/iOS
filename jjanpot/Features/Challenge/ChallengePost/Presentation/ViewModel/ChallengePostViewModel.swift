//
//  ChallengePostViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//


import SwiftUI
import Combine
final class ChallengePostViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var toastMessage: String?
    private let challengeId: Int
    
    private let useCase: ChallengePostUseCaseProtocol
    init(challengeId: Int, useCase: ChallengePostUseCaseProtocol) {
        self.challengeId = challengeId
        self.useCase = useCase
    }
}


