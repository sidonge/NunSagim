import SwiftUI
import AVFoundation

struct ConsonantCardView: View {
    @State private var currentIndex: Int = 0
    @EnvironmentObject var bleManager: BLEManager
    private let synthesizer = AVSpeechSynthesizer()

    let cards: [BrailleStudyCard] = [
        BrailleStudyCard(title: "ㄹ", description: "자음 ㄹ은 혀끝이 입천장에 닿으며 발음됩니다.", imageName: "consonant_l"),
        BrailleStudyCard(title: "ㅊ", description: "자음 ㅊ은 치찰음으로 강한 기운을 담아 발음합니다.", imageName: "consonant_ch"),
        BrailleStudyCard(title: "ㅋ", description: "자음 ㅋ은 세게 나오는 기식음입니다.", imageName: "consonant_k"),
        BrailleStudyCard(title: "ㅌ", description: "자음 ㅌ은 혀끝이 윗잇몸에 닿으며 발음됩니다.", imageName: "consonant_t"),
        BrailleStudyCard(title: "ㅍ", description: "자음 ㅍ은 양입술을 닫았다가 터뜨리며 발음합니다.", imageName: "consonant_p")
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Color.white
                    .frame(height: 8)
                    .ignoresSafeArea(edges: .top)

                Divider()
                    .frame(height: 0.6)
                    .background(Color(hex: "#CECECE"))

                Text("점자 출력기를 연결하고 카드를 터치해 보세요!")
                    .font(.system(size: 18))
                    .padding(.top, 60)
                    .padding(.bottom, 1)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                GeometryReader { geometry in
                    ScrollViewReader { scrollReader in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(cards.indices, id: \.self) { index in
                                    let isCurrent = index == currentIndex

                                    VStack(spacing: 12) {
                                        if isCurrent {
//                                            Text(cards[index].title)
//                                                .font(.largeTitle.bold())

                                            if !cards[index].imageName.isEmpty {
                                                Image(cards[index].imageName)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 90, height: 90)
                                            }
                                        } else {
                                            Spacer()
                                        }
                                    }
                                    .frame(width: isCurrent ? 279 : 35,
                                           height: isCurrent ? 386 : 313)
                                    .background(
                                        Color(hex: "#FDEFC6")
                                            .clipShape(RoundedRectangle(cornerRadius: isCurrent ? 20 : 10))
                                    )
                                    .compositingGroup()
                                    .clipShape(RoundedRectangle(cornerRadius: isCurrent ? 20 : 10))
                                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
                                    .offset(y: isCurrent ? -20 : 30)
                                    .padding(.horizontal, isCurrent ? 16 : 5)
                                    .padding(.top, 100)
                                    .animation(.easeInOut(duration: 0.15), value: currentIndex)
                                    .id(index)
                                    .onTapGesture {
                                        currentIndex = index
                                        speak(cards[index].description)
                                        sendToArduino(cards[index].title)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 40)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        let threshold: CGFloat = 50
                                        let previousIndex = currentIndex

                                        if value.translation.width < -threshold {
                                            currentIndex = min(currentIndex + 1, cards.count - 1)
                                        } else if value.translation.width > threshold {
                                            currentIndex = max(currentIndex - 1, 0)
                                        }

                                        if currentIndex != previousIndex {
                                            withAnimation {
                                                scrollReader.scrollTo(currentIndex, anchor: .center)
                                            }
                                            synthesizer.stopSpeaking(at: .immediate)
                                        }
                                    }
                            )
                        }
                        .onAppear {
                            scrollReader.scrollTo(currentIndex, anchor: .center)
                            synthesizer.stopSpeaking(at: .immediate)
                        }
                    }
                }
                .frame(height: 386)

                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("점자 카드")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        synthesizer.speak(utterance)
    }

    func sendToArduino(_ text: String) {
        bleManager.sendBraille(text: text)
    }
}

#Preview {
    ConsonantCardView()
        .environmentObject(BLEManager())
}
