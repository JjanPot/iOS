//
//  InviteCodeViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//


import SwiftUI
import Combine

final class InviteCodeViewModel: ObservableObject {
    @Published var inviteCodeErrorMessage: String? = nil
}
