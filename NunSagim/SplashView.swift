//
//  SplashView.swift
//  NunSagim
//
//  Created by 정시은 on 5/22/25.
//
import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color(hex: "#FFCE63")
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    Spacer()
                    Text("당신의 눈이 되어주는")
                        .font(.custom("Pretendard-Regular", size: 23))
                        .foregroundColor(Color(hex: "#FFFFFF"))
                    Image("whitelogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(.bottom, 100)
                        .padding(.top, 10)
                    Spacer()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
