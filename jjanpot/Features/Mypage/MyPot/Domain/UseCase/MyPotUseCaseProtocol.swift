//
//  MyPotUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


protocol MyPotUseCaseProtocol {
    
}
struct MyPotUseCase: MyPotUseCaseProtocol {
    private let repository: MyPotRepositoryProtocol
    init(repository: MyPotRepositoryProtocol) {
        self.repository = repository
    }
    
    
    
}


