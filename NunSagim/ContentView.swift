//
//  ContentView.swift
//  NunSagim
//
//  Created by 정시은 on 5/16/25.
//
import SwiftUI

//MARK: - ContentView (최상위 TabView)
struct ContentView: View {
    @State private var selectedTab = 0
    @State private var selectedType: String? = nil
    @EnvironmentObject var bleManager: BLEManager

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeScreenView()
                    .tabItem {
                        Image("home")
                    }
                    .tag(0)

                LectureView()
                    .tabItem {
                        Image("book")
                    }
                    .tag(1)

                CameraView()
                    .tabItem {
                        Image("camera")
                    }
                    .tag(2)

                BrailleCardSelectionView(selectedType: $selectedType)
                                    .tabItem {
                                        Image("cardIcon")
                    }
                    .tag(3)
            }

            Rectangle()
                .fill(Color(hex: "#A5A5A5"))
                .frame(height: 0.6)
                .edgesIgnoringSafeArea(.bottom)
                .padding(.bottom, 60)
        }
    }
}

//HomeScreenView
struct HomeScreenView: View {
    var body: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
    }
}

//HomeView
struct HomeView: View {
    @EnvironmentObject var bleManager: BLEManager

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image("logo")
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)


            Divider()
                .frame(height: 0.6)
                .background(Color(hex: "#CECECE"))
                .padding(.top, 15)
                .padding(.bottom, 15)

            VStack(alignment: .leading, spacing: 20) {
                //상단 문구
                VStack(alignment: .leading, spacing: 10) {
                    Text("오늘도 눈새김과 함께해요! 👋")
                        .font(.custom("Pretendard-Bold", size: 22))
                        .padding(.top, 6)
                        .foregroundColor(Color(hex: "#484848"))

                    Text("오늘의 점자, 준비되셨나요?")
                        .font(.custom("Pretendard-Medium", size: 15))
                        .foregroundColor(Color(hex: "#484848"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                //상단 카드 박스
                HStack(spacing: 20) {
                    BrailleCard(braille: "⠑", korean: "ㅁ")
                    BrailleCard(braille: "⠊", korean: "ㄷ")
                    BrailleCard(braille: "⠣", korean: "ㅏ")
                    BrailleCard(braille: "⠕", korean: "ㅣ")
                }
                .frame(width: 362, height: 131)
                .background(Color(hex: "FFF0D0"))
                .cornerRadius(25)

                //점자 퀴즈 박스
                NavigationLink(destination: QuizView().environmentObject(bleManager)) {
                    HStack {
                        Image("quizIcon")
                        VStack(alignment: .leading, spacing: 4) {
                            Text("점자퀴즈")
                                .font(.custom("Pretendard-Bold", size: 16))
                                .padding(.bottom, 10)
                                .foregroundColor(Color(hex: "#484848"))
                            Text("매일 매일 퀴즈를 통해\n10개씩 점자 학습하기")
                                .font(.custom("Pretendard-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(5)
                        Spacer()
                        Image("rightBtn")
                    }
                    .padding()
                    .background(Color(hex: "FFF0D0"))
                    .cornerRadius(25)
                }
                .buttonStyle(PlainButtonStyle())

                //추천 단어 박스
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("오늘의 추천 단어")
                            .font(.custom("Pretendard-Bold", size: 16))
                            .padding(.top, 10)
                            .foregroundColor(Color(hex: "#484848"))

                        Spacer()

                        NavigationLink(destination: CardView()) {
                            Text("더 다양한 단어 공부하기 >")
                                .font(.custom("Pretendard-Medium", size: 12))
                                .padding(.top, 10)
                                .foregroundColor(Color(hex: "#ABABAB"))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    VStack(alignment: .leading, spacing: 30) {
                        HStack(spacing: 8) {
                            ForEach(["강", "아", "지"], id: \.self) { char in
                                StaticBrailleBox(text: char)
                            }
                            Spacer().frame(width: 10)
                            ForEach(["⠫", "⠶", "⠣", "⠨", "⠕"], id: \.self) { braille in
                                StaticBrailleBox(text: braille)
                            }
                        }

                        HStack(spacing: 8) {
                            ForEach(["별", "빛"], id: \.self) { char in
                                StaticBrailleBox(text: char)
                            }
                            Spacer().frame(width: 10)
                            ForEach(["⠘", "⠳", "⠘", "⠕", "⠆"], id: \.self) { braille in
                                StaticBrailleBox(text: braille)
                            }
                        }
                        .padding(.bottom, 25)
                    }
                    .padding(.top, 10)
                }
                .padding()
                .background(Color(hex: "FFF0D0"))
                .cornerRadius(25)
            }
            .padding([.horizontal, .bottom])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.bottom, 15)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct BrailleCard: View {
    let braille: String
    let korean: String
    @State private var isTapped = false
    @EnvironmentObject var bleManager: BLEManager

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(isTapped ? Color(hex: "FCAC00") : Color.white)

            Text(isTapped ? korean : braille)
                .font(.custom("Pretendard-Bold", size: isTapped ? 42 : 50))
                .foregroundColor(isTapped ? .white : .black)
                .frame(width: 60, height: 83)
                .multilineTextAlignment(.center)
                .offset(x: isTapped ? 0 : 5, y: isTapped ? 0 : -1)
        }
        .frame(width: 60, height: 83)
        .onTapGesture {
            isTapped.toggle()
            bleManager.sendBraille(text: korean)
        }
    }
}

struct StaticBrailleBox: View {
    let text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .frame(width: 31, height: 43)

            Text(text)
                .font(.custom("Pretendard-Bold", size: 30))
                .foregroundColor(Color(hex: "FCAC00"))
        }
        .padding(.top, 10)
    }
}



extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

extension Font {
    enum PretendardWeight {
        case black
        case bold
        case heavy
        case ultraLight
        case light
        case medium
        case regular
        case semibold
        case thin
        
        var value: String {
            switch self {
            case .black:
                return "Black"
            case .bold:
                return "Bold"
            case .heavy:
                return "ExtraBold"
            case .ultraLight:
                return "ExtraLight"
            case .light:
                return "Light"
            case .medium:
                return "Medium"
            case .regular:
                return "Regular"
            case .semibold:
                return "SemiBold"
            case .thin:
                return "Thin"
            }
        }
    }
    
    static func pretendard(_ weight: PretendardWeight, size fontSize: CGFloat) -> Font {
        let familyName = "Pretendard"
        let weightString = weight.value
        
        return Font.custom("\(familyName)-\(weightString)", size: fontSize)
    }
}

#Preview {
    ContentView()
        .environmentObject(BLEManager())
}
