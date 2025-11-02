import SwiftUI

struct LetterGardenGameView: View {
    @ObservedObject var viewModel: LetterGardenGameViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
                .overlay(CanopyLightsOverlay())

            VStack(spacing: 20) {
                header

                if viewModel.isComplete {
                    completionCard
                } else {
                    promptCard
                    letterGrid
                    Spacer()
                }

                if let feedback = viewModel.feedback {
                    FeedbackBanner(feedback: feedback)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding()
        }
        .animation(.easeInOut, value: viewModel.feedback?.message)
        .animation(.easeInOut, value: viewModel.isComplete)
        .onAppear {
            viewModel.enableAudioPrompts()
        }
        .onDisappear {
            viewModel.disableAudioPrompts()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            ProgressView(value: viewModel.progress)
                .progressViewStyle(.linear)
                .tint(Color(hex: "F59E0B"))

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Letter Garden")
                        .font(.title2.bold())
                    Text("Round \(viewModel.roundNumber) of 6")
                        .font(.callout)
                        .foregroundColor(Color.white.opacity(0.75))
                }

                Spacer()

                Text("Score \(viewModel.score)")
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.white.opacity(0.18)))
                    .foregroundColor(Color(hex: "FDE68A"))
                    .overlay(
                        Image(systemName: "bird")
                            .font(.caption)
                            .foregroundColor(Color.white.opacity(0.7))
                            .offset(x: 20, y: -18)
                    )
            }
        }
        .padding(.horizontal, 4)
    }

    private var promptCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.promptText)
                    .font(.title3.bold())
                    .foregroundColor(Color(hex: "0F172A"))
                Text(viewModel.helperText)
                    .font(.callout)
                    .foregroundColor(Color(hex: "334155"))
            }

            if let clue = viewModel.promptClue {
                HStack(alignment: .center, spacing: 12) {
                    Text(clue)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(Color(hex: "0F172A"))
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                        .foregroundColor(Color(hex: "0D9488"))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white.opacity(0.85))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color(hex: "0D9488").opacity(0.25), lineWidth: 1)
                        )
                )
            }

            Button(action: viewModel.replayPromptAudio) {
                Label("Hear it again", systemImage: "speaker.wave.2.fill")
                    .font(.subheadline.weight(.semibold))
            }
            .tint(Color(hex: "0D9488"))
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "FDE68A"), Color.white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color(hex: "FACC15").opacity(0.35), lineWidth: 1.5)
                )
        )
        .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 10)
    }

    private var letterGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.choices) { card in
                Button {
                    viewModel.select(card: card)
                } label: {
                    LetterTileCard(card: card)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var completionCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundColor(Color(hex: "F59E0B"))
            Text("Alphabet superstar!")
                .font(.title2.bold())
                .foregroundColor(Color(hex: "0F172A"))
            Text("You matched \(viewModel.score) letters and sounds. Keep listening and reading together!")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "1E293B"))

            Button(action: viewModel.startGame) {
                Label("Play again", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Color(hex: "F59E0B")))
                    .foregroundColor(Color(hex: "0F172A"))
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white.opacity(0.95))
        )
        .shadow(color: Color.black.opacity(0.12), radius: 18, x: 0, y: 8)
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "052E1C"),
                Color(hex: "0F5132")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

private struct LetterTileCard: View {
    let card: LetterGardenGameViewModel.LetterCard

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(card.letter.uppercase)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "0F172A"))
                Text(card.letter.lowercase)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "0D9488"))
            }
            Text("\(card.letter.clueEmoji) \(card.letter.keyword.capitalized)")
                .font(.callout)
                .foregroundColor(Color(hex: "4B5563"))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color(hex: "0D9488").opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}

private struct FeedbackBanner: View {
    let feedback: LetterGardenGameViewModel.Feedback

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: feedback.isPositive ? "hand.thumbsup.fill" : "ear")
                .foregroundColor(.white)
            Text(feedback.message)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill((feedback.isPositive ? Color(hex: "22C55E") : Color(hex: "F97316")))
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#if DEBUG
struct LetterGardenGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LetterGardenGameView(viewModel: LetterGardenGameViewModel())
        }
    }
}
#endif

private struct CanopyLightsOverlay: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "FACC15").opacity(0.18))
                .frame(width: 220)
                .blur(radius: 80)
                .offset(x: -120, y: -260)
            Circle()
                .fill(Color(hex: "5EEAD4").opacity(0.22))
                .frame(width: 240)
                .blur(radius: 90)
                .offset(x: 160, y: -180)
            Circle()
                .fill(Color(hex: "F97316").opacity(0.15))
                .frame(width: 300)
                .blur(radius: 120)
                .offset(x: -60, y: 260)
        }
    }
}
