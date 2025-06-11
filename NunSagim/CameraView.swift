////
////  CameraView.swift
////  NunSagim
////
////  Created by 정시은 on 5/17/25.
////
////
//import SwiftUI
//import WebKit
//
//
//
//struct CameraView: View {
//    var body: some View {
//        WebView(url: URL(string: "https://cool-orca-sincere.ngrok-free.app")!)
//            .edgesIgnoringSafeArea(.all)
//            .navigationTitle("실시간 객체 인식")
//            .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//// MARK: - WebView Wrapper
//struct WebView: UIViewRepresentable {
//    let url: URL
//
//    func makeUIView(context: Context) -> WKWebView {
//        return WKWebView()
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        let request = URLRequest(url: url)
//        uiView.load(request)
//    }
//}
//
//#Preview {
//    CameraView()
//}

import SwiftUI
import WebKit

struct CameraView: View {
    var body: some View {
        WebView(url: URL(string: "https://cool-orca-sincere.ngrok-free.app")!)
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("실시간 객체 인식")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - WebView Wrapper
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webpagePreferences = WKWebpagePreferences()
        webpagePreferences.allowsContentJavaScript = true

        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = webpagePreferences
        config.allowsInlineMediaPlayback = true
        config.suppressesIncrementalRendering = false
        config.websiteDataStore = .nonPersistent()

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
