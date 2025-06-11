import SwiftUI
import AVFoundation

struct CardView: View {
    @State private var currentIndex: Int = 0
    @EnvironmentObject var bleManager: BLEManager
    private let synthesizer = AVSpeechSynthesizer()

    let cards: [BrailleStudyCard] = [
        BrailleStudyCard(title: "사과", description: "사과는 빨간색 과일입니다.", imageName: "apple"),
        BrailleStudyCard(title: "바나나", description: "바나나는 노란색 과일입니다.", imageName: "banana"),
        BrailleStudyCard(title: "감자", description: "감자는 땅속에서 자랍니다.", imageName: "potato"),
        BrailleStudyCard(title: "뱀", description: "뱀은 길고 다리가 없습니다.", imageName: "snake"),
        BrailleStudyCard(title: "종이", description: "종이는 글을 쓸 때 사용됩니다.", imageName: "paper")
    ]

    var body: some View {
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
                                        Text(cards[index].title)
                                            .font(.largeTitle.bold())

                                        Image(cards[index].imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 180)
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
