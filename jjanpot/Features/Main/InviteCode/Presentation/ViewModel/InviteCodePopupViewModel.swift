//
//  InviteCodePopupViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/27/26.
//

import Foundation
import Combine

final class InviteCodePopupViewModel: ObservableObject {
    
    func checkInviteCode( _ code: String)  {
        print(">>>>> 코드확인하기 \(code)")
    }
}
