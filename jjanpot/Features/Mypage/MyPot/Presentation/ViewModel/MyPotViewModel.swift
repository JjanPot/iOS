//
//  MyPotViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


import SwiftUI
import Combine
final class MyPotViewModel: ObservableObject {
 @Published var isLoading = false
    @Published var toastMessage: String?

     private let useCase: MyPotUseCaseProtocol
    init(useCase: MyPotUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func logout(){
        
    }
}
