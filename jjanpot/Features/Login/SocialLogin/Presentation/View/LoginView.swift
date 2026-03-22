//
//  LoginView.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    init(viewModel: LoginViewModel){
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Button {
            viewModel.clickAppleLoginButton()
        } label: {
            Text("애플 로그인")
        }
        
        Button {
            viewModel.clickKakaoLoginButton()
        } label: {
            Text("카카오 로그인")
        }

    }
}

#Preview {
    AppDIContainer.shared.makeLoginView(onDismiss: {})
}
