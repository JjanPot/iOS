//
//  AdvancedWebView.swift
//  jjanpot
//
//  Created by 임주희 on 3/24/26.
//


import Foundation
import UIKit
import SwiftUI
import WebKit

struct WebView: View {
    let url: String
    let onDismiss: () -> Void
    
    init(url: String, onDismiss: @escaping () -> Void) {
        self.url = url
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        NavigationStack {
            AdvancedWebView(
                url: URL(string: url)!,
                isLoading: .constant(false)
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct AdvancedWebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: AdvancedWebView
        
        init(_ parent: AdvancedWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
}
