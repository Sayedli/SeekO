import SwiftUI

struct LetterGardenGameView: View {
    @ObservedObject var viewModel: LetterGardenGameViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
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
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .animation(.easeInOut, value: viewModel.feedback?.message)
        .animation(.easeInOut, value: viewModel.isComplete)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            ProgressView(value: viewModel.progress)
                .progressViewStyle(.linear)
                .tint(Color(hex: "9C27B0"))

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Letter Garden")
                        .font(.title2.bold())
                    Text("Round \(viewModel.roundNumber) of 6")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text("Score \(viewModel.score)")
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color(hex: "F48FB1").opacity(0.25)))
            }
        }
    }

    private var promptCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.promptText)
                    .font(.title3.bold())
                Text(viewModel.helperText)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }

            Button(action: viewModel.replayPromptAudio) {
                Label("Hear it again", systemImage: "speaker.wave.2.fill")
                    .font(.subheadline.weight(.semibold))
            }
            .tint(Color(hex: "9C27B0"))
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
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
                .foregroundColor(Color(hex: "9C27B0"))
            Text("Alphabet superstar!")
                .font(.title2.bold())
            Text("You matched \(viewModel.score) letters and sounds. Keep listening and reading together!")
                .font(.body)
                .multilineTextAlignment(.center)

            Button(action: viewModel.startGame) {
                Label("Play again", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Color(hex: "9C27B0")))
                    .foregroundColor(.white)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 28).fill(Color.white))
        .shadow(color: Color.black.opacity(0.12), radius: 18, x: 0, y: 8)
    }
}

private struct LetterTileCard: View {
    let card: LetterGardenGameViewModel.LetterCard

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(card.letter.uppercase)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "5E35B1"))
                Text(card.letter.lowercase)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "AB47BC"))
            }
            Text("“\(card.letter.keyword.capitalized)”")
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white))
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
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
                .fill((feedback.isPositive ? Color(hex: "8BC34A") : Color(hex: "FF7043")))
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
