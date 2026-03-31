//
//  InviteCodePopupRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation

protocol InviteCodePopupRepositoryProtocol {
    func submitInviteCode(code: String) async throws
}
