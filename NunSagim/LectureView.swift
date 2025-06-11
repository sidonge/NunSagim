import SwiftUI
import AVKit

struct LectureView: View {
    @State private var selectedAge: String? = nil
    @State private var navigate = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("강의 보기")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "#484848"))
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .background(Color.white)

                    Divider()
                        .frame(height: 0.6)
                        .background(Color(hex: "#CECECE"))
                        .padding(.horizontal, 0)
                }

                HStack {
                    Text("연령대 선택하기")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "#484848"))
                        .padding(.top, 25)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 24)
                    Spacer()
                }

                VStack(spacing: 16) {
                    ForEach(["어린이", "청소년", "성인"], id: \.self) { age in
                        Button(action: {
                            selectedAge = age
                            navigate = true
                        }) {
                            LectureAgeCard(
                                imageName: age == "어린이" ? "child" : age == "청소년" ? "teen" : "adult",
                                title: age,
                                isSelected: selectedAge == age,
                                bgColor: selectedAge == age ? "#FDEFC6" : "#F4F5F7"
                            )
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)

                NavigationLink(
                    destination: LectureDetailView(ageGroup: selectedAge ?? ""),
                    isActive: $navigate,
                    label: { EmptyView() }
                )

                Spacer()
            }
        }
    }
}

struct LectureAgeCard: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    let bgColor: String

    var body: some View {
        HStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .frame(width: 66, height: 66)

            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#484848"))

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: bgColor))
        )
    }
}

struct LectureDetailView: View {
    let ageGroup: String
    @State private var selectedIndex: Int? = nil

    var lectures: [(title: String, subtitle: String)] {
        switch ageGroup {
        case "청소년":
            return [
                (title: "[쉬운 단어 배우기]", subtitle: "1. 일상 속 기본 단어"),
                (title: "[쉬운 단어 배우기]", subtitle: "2. 음식과 과일 단어"),
                (title: "[쉬운 단어 배우기]", subtitle: "3. 자연 속 동식물 단어"),
                (title: "[쉬운 단어 배우기]", subtitle: "4. 숫자와 색깔 단어")
            ]
        case "성인":
            return [
                (title: "[기초 문장 배우기]", subtitle: "1. 인사와 자기소개 표현"),
                (title: "[기초 문장 배우기]", subtitle: "2. 일상생활 속 대화 표현"),
                (title: "[기초 문장 배우기]", subtitle: "3. 도움 요청과 응답 표현"),
                (title: "[기초 문장 배우기]", subtitle: "4. 감정 표현과 간단한 소통")
            ]
        default:
            return [
                (title: "쉽게 배우는 점자 핵심", subtitle: "1. OT 및 자음"),
                (title: "쉽게 배우는 점자 핵심", subtitle: "2. 모음"),
                (title: "쉽게 배우는 점자 핵심", subtitle: "3. 약자"),
                (title: "쉽게 배우는 점자 핵심", subtitle: "4. 문장 부호 및 숫자/연산")
            ]
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // ✅ 추가된 상단 구분선
            Divider()
                .frame(height: 0.6)
                .background(Color(hex: "#CECECE"))
            
            VStack(spacing: 0) {
                Text("연령대 선택하기 > \(ageGroup)")
                    .font(.system(size: 13))
                    .foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 5)
                
                Divider()
                    .frame(height: 0.5)
                    .background(Color(hex: "#CECECE"))
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("[점자] 백무근 선생님")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    Text(ageGroup == "어린이" ? "쉽게 배우는 점자 일람표" :
                            ageGroup == "청소년" ? "청소년 단어 학습 강의" :
                            "성인 문장 학습 강의")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                }
                Spacer()
                Image("braille")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
            }
            .padding()
            .background(Color(hex: "#FFC84B"))
            
            HStack {
                Spacer()
                Text("전체 강의(\(lectures.count))")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 16)
            .padding(.top, 10)
            
            Divider()
                .frame(height: 0.5)
                .background(Color(hex: "#CECECE"))
                .padding(.top, 10)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(0..<lectures.count, id: \.self) { index in
                        NavigationLink(
                            destination: VideoPlayerView(videoName: videoFileName(for: ageGroup, index: index)),
                            tag: index,
                            selection: $selectedIndex,
                            label: {
                                VStack(spacing: 0) {
                                    HStack {
                                        Image(systemName: "play.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(index == selectedIndex ? Color(hex: "#F9A825") : Color.gray)
                                            .padding(.trailing, 20)
                                            .padding(.leading, 4)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(lectures[index].title)
                                                .font(.system(size: 17, weight: .bold))
                                                .foregroundColor(index == selectedIndex ? Color(hex: "#F9A825") : Color(hex: "#333333"))
                                            Text(lectures[index].subtitle)
                                                .font(.system(size: 15))
                                                .foregroundColor(index == selectedIndex ? Color(hex: "#F9A825") : Color(hex: "#ABABAB"))
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(index == selectedIndex ? Color(hex: "#FFF1C3") : Color.white)
                                    )
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .background(Color(hex: "#E0E0E0"))
                                        .padding(.horizontal, 0.1)
                                }
                            }
                        )
                    }
                }
            }
            .padding(.top, 0)
        }
        .background(Color.white)
        .navigationTitle("강의 보기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    func videoFileName(for ageGroup: String, index: Int) -> String {
        switch ageGroup {
        case "청소년":
            return "teen_lecture\(index)"
        case "성인":
            return "adult_lecture\(index)"
        default:
            return "kid_lecture\(index)"
        }
    }
}

struct VideoPlayerView: View {
    let videoName: String

    var body: some View {
        if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
            let player = AVPlayer(url: URL(fileURLWithPath: path))
            VideoPlayer(player: player)
                .onAppear {
                    player.play()
                }
                .navigationTitle("강의 영상")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            Text("비디오를 찾을 수 없습니다.")
                .foregroundColor(.red)
        }
    }
}

#Preview {
    LectureView()
}
