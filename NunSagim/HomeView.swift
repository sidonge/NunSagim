//
//  HomeView.swift
//  NunSagim
//
//  Created by 정시은 on 5/17/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        AppMainLayout {
            VStack(alignment: .leading) {
                Text("오늘도 눈새김과 함께해요! 👋")
                    .font(.headline)
                Text("오늘의 점자, 준비되셨나요?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
