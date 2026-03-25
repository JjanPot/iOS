//
//  ProfileSetupViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//


import SwiftUI

import Combine
final class ProfileSetupViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var nicknameErrorMessage: String? = nil
    @Published var birthDate: Date? = nil
}
