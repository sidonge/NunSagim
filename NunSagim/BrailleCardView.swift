import SwiftUI

struct BrailleType: Identifiable {
    let id: String
    let label: String
    let image: String
    let size: CGSize
}

struct BrailleCardSelectionView: View {
    @Binding var selectedType: String?
    @EnvironmentObject var bleManager: BLEManager
    @State private var isNavigating = false

    let types: [BrailleType] = [
        BrailleType(id: "consonant", label: "자음", image: "consonant", size: CGSize(width: 64, height: 74)),
        BrailleType(id: "vowel", label: "모음", image: "vowels", size: CGSize(width: 68, height: 71)),
        BrailleType(id: "word", label: "단어", image: "word", size: CGSize(width: 64, height: 64))
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("점자 카드")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "#484848"))
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .background(Color.white)

                    Divider()
                        .frame(height: 0.6)
                        .background(Color(hex: "#CECECE"))
                }

                HStack {
                    Text("학습 유형 선택하기")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "#484848"))
                        .padding(.top, 25)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 24)
                    Spacer()
                }

                VStack(spacing: 16) {
                    ForEach(types) { type in
                        Button(action: {
                            selectedType = type.id
                            isNavigating = true
                        }) {
                            HStack(spacing: 20) {
                                Image(type.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: type.size.width, height: type.size.height)

                                Text(type.label)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(hex: "#484848"))

                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(hex: selectedType == type.id ? "#FDEABE" : "#F4F5F7"))
                            )
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)

                Spacer()

                NavigationLink(
                    destination: destinationView(),
                    isActive: $isNavigating,
                    label: { EmptyView() }
                )
                .hidden()
            }
        }
    }

    @ViewBuilder
    private func destinationView() -> some View {
        switch selectedType {
        case "consonant":
            ConsonantCardView()
        case "vowel":
            VowelCardView()
        case "word":
            CardView()
        default:
            EmptyView()
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedType: String? = nil

        var body: some View {
            BrailleCardSelectionView(selectedType: $selectedType)
                .environmentObject(BLEManager())
        }
    }
    return PreviewWrapper()
}

