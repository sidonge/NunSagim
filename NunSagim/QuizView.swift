//
//  QuizView.swift
//  NunSagim
//
//  Created by 정시은 on 5/17/25.

import SwiftUI

struct Question {
    let imageName: String
    let options: [String]
    let answer: String
}

struct QuizView: View {
    @EnvironmentObject var bleManager: BLEManager
    @State private var selectedOption: String? = nil
    @State private var questions: [Question] = [
        Question(imageName: "ㄱ", options: ["ㄱ", "ㅂ", "ㅎ"], answer: "ㄱ"),
        Question(imageName: "ㄴ", options: ["ㄷ", "ㄴ", "ㅁ"], answer: "ㄴ"),
        Question(imageName: "ㄷ", options: ["ㅅ", "ㄷ", "ㅈ"], answer: "ㄷ"),
        Question(imageName: "ㅎ", options: ["ㅍ", "ㅎ", "ㅋ"], answer: "ㅎ"),
        Question(imageName: "ㅏ", options: ["ㅓ", "ㅡ", "ㅏ"], answer: "ㅏ"),
        Question(imageName: "ㅓ", options: ["ㅜ", "ㅗ", "ㅓ"], answer: "ㅓ"),
        Question(imageName: "ㅗ", options: ["ㅗ", "ㅣ", "ㅐ"], answer: "ㅗ"),
        Question(imageName: "ㅣ", options: ["ㅓ", "ㅡ", "ㅣ"], answer: "ㅣ"),
        Question(imageName: "가", options: ["나", "가", "하"], answer: "가"),
        Question(imageName: "나", options: ["라", "다", "나"], answer: "나")
    ]

    @State private var currentIndex = 0
    @State private var showCorrectOverlay = false
    @State private var showWrongOverlay = false
    @State private var showResult = false
    @State private var score = 0
    @State private var isOptionDisabled = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
            ZStack {
                VStack {
                    if showResult {
                        Spacer()
                        VStack(spacing: 16) {
                            Image("handclap")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("축하합니다!\n총 \(score)/10 문제 맞혔어요")
                                .multilineTextAlignment(.center)
                                .padding()
                            Text("다음 퀴즈에서 또 만나요")
                                .foregroundColor(.gray)
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("닫기")
                                    .font(.custom("Pretendard-Bold", size: 16))
                                    .padding()
                                    .frame(width: 120)
                                    .background(Color(hex: "#FCAC00"))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                        Spacer()
                    } else {
                        VStack(spacing: 15) {
                            Text("Q\(currentIndex + 1)")
                                .font(.custom("Pretendard-Bold", size: 20))
                                .frame(width: 100, height: 45)
                                .background(
                                    RoundedRectangle(cornerRadius: 60)
                                        .fill(Color(hex: "#FEF0D0"))
                                )
                                

                            Image(questions[currentIndex].imageName)
                                .padding()
                                .onAppear {
                                    let correctAnswer = questions[currentIndex].answer
                                        bleManager.sendBraille(text: correctAnswer)
                                }
                                .onChange(of: currentIndex) { _, newIndex in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        let correctAnswer = questions[newIndex].answer
                                        bleManager.sendBraille(text: correctAnswer)
                                    }
                                }




                            ForEach(questions[currentIndex].options.indices, id: \.self) { index in
                                let option = questions[currentIndex].options[index]
                                Button(action: {
                                    handleAnswer(option)
                                }) {
                                    Text(option)
                                        .font(.custom("Pretendard-ExtraBold", size: 22))
                                        .foregroundStyle(Color(hex: "484848"))
                                        .frame(width: 290, height: 32)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 60)
                                                .fill(option == selectedOption ? Color(hex: "#FEF0D0") : Color(hex: "#F5F5F5"))
                                        )
                                }
                                .disabled(isOptionDisabled)
                            }

                            Text("\(currentIndex + 1) / 10")
                                .padding(.top, 10)

                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .frame(height: 15)
                                        .foregroundColor(Color(hex: "#F5F5F5"))
                                    Capsule()
                                        .frame(width: geometry.size.width * CGFloat(currentIndex + 1) / 10, height: 14)
                                        .foregroundColor(Color(hex: "FCAC00"))
                                }
                            }
                            .frame(height: 8)
                            .padding(.horizontal)
                        }
                        .padding()
                    }
                }

                if showCorrectOverlay {
                    overlayCard(imageName: "congraduation", title: "정답이에요!", subtitle: nil, offsetY: -100)
                } else if showWrongOverlay {
                    overlayCard(imageName: "sadface", title: "오답이에요!", subtitle: "정답: \(questions[currentIndex].answer)", offsetY: -50)
                }
            
        }
    }

    @ViewBuilder
    private func overlayCard(imageName: String, title: String, subtitle: String?, offsetY: CGFloat) -> some View {
        VStack(spacing: 12) {
            Image(imageName)
                .resizable()
                .frame(width: 100, height: 100)
            Text(title)
                .font(.custom("Pretendard-ExtraBold", size: 20))
                .foregroundColor(Color(hex: "#484848"))
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.custom("Pretendard-Regular", size: 12))
                    .foregroundColor(Color(hex: "#484848"))
            }
        }
        .padding()
        .frame(width: 250, height: 250)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .position(x: UIScreen.main.bounds.width / 2,
                  y: UIScreen.main.bounds.height / 2 + offsetY)
        .animation(.easeInOut, value: showCorrectOverlay || showWrongOverlay)
    }

    private func handleAnswer(_ selected: String) {
        selectedOption = selected
        isOptionDisabled = true

        //아두이노로 정답 전송하는 부분
        let correctAnswer = questions[currentIndex].answer
        bleManager.sendBraille(text: correctAnswer)

        if selected == correctAnswer {
            score += 1
            showCorrectOverlay = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showCorrectOverlay = false
                isOptionDisabled = false
                moveToNextQuestion()
            }
        } else {
            showWrongOverlay = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showWrongOverlay = false
                isOptionDisabled = false
                moveToNextQuestion()
            }
        }
    }

    private func moveToNextQuestion() {
        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            showResult = true
        }
    }
}

#Preview {
    QuizView()
            .environmentObject(BLEManager())
}
