//
//  InviteCodePopupUseCase.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


import Foundation

protocol InviteCodePopupUseCaseProtocol {
    func submitInviteCode(code: String) async throws
}
struct InviteCodePopupUseCase: InviteCodePopupUseCaseProtocol {
    private let repository: InviteCodePopupRepositoryProtocol
    init(repository: InviteCodePopupRepositoryProtocol) {
        self.repository = repository
    }
    
    
    func submitInviteCode(code: String) async throws {
        try await repository.submitInviteCode(code: code)
    }
    
}


