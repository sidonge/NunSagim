//
//  NunSagimApp.swift
//  NunSagim
//
//  Created by 정시은 on 5/16/25.
//

import SwiftUI

@main
struct NunSagimApp: App {
    @StateObject var bleManager = BLEManager()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(bleManager)
        }
    }
}
