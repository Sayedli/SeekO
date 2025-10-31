import SwiftUI

struct ShapeGardenGameView: View {
    @ObservedObject var viewModel: ShapeGardenGameViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
                .overlay(TreetopGlowOverlay())

            VStack(spacing: 20) {
                header

                if viewModel.isComplete {
                    completionCard
                } else {
                    promptCard
                    shapeGrid
                    Spacer()
                }

                if let feedback = viewModel.feedback {
                    FeedbackBanner(feedback: feedback)
                }
            }
            .padding()
        }
        .animation(.easeInOut, value: viewModel.feedback?.message)
        .animation(.easeInOut, value: viewModel.isComplete)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            ProgressView(value: viewModel.progress)
                .progressViewStyle(.linear)
                .tint(Color(hex: "34D399"))
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Shape Garden")
                        .font(.title2.bold())
                        .foregroundColor(Color(hex: "ECFCCB"))
                    Text("Round \(viewModel.roundNumber) of 6")
                        .font(.callout)
                        .foregroundColor(Color(hex: "A7F3D0"))
                }

                Spacer()

                Text("Score \(viewModel.score)")
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.white.opacity(0.15)))
                    .foregroundColor(Color(hex: "FDE68A"))
                    .overlay(
                        Image(systemName: "leaf.circle.fill")
                            .font(.caption)
                            .foregroundColor(Color(hex: "BBF7D0"))
                            .offset(x: 18, y: -18)
                    )
            }
        }
        .padding(.horizontal, 4)
    }

    private var promptCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.promptText)
                .font(.title3.bold())
            Text("Listen carefully and tap the matching shape to grow the garden.")
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
    }

    private var shapeGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.choices) { card in
                Button {
                    viewModel.select(card: card)
                } label: {
                    ShapeTileCard(card: card)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var completionCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundColor(Color(hex: "FFB703"))
            Text("You helped the garden bloom!")
                .font(.title2.bold())
            Text("You matched \(viewModel.score) shapes. Fantastic listening and matching skills!")
                .font(.body)
                .multilineTextAlignment(.center)

            Button(action: viewModel.startGame) {
                Label("Play again", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Color(hex: "219EBC")))
                    .foregroundColor(.white)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 28).fill(Color.white))
        .shadow(color: Color.black.opacity(0.12), radius: 18, x: 0, y: 8)
    }
}

private struct ShapeTileCard: View {
    let card: ShapeGardenGameViewModel.ShapeCard

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: card.type.systemImageName)
                .font(.system(size: 52))
                .foregroundColor(Color(hex: card.colorHex))
                .shadow(color: Color(hex: card.colorHex).opacity(0.2), radius: 8, x: 0, y: 4)
            Text(card.type.displayName.capitalized)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white))
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

private struct FeedbackBanner: View {
    let feedback: ShapeGardenGameViewModel.Feedback

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: feedback.isPositive ? "hand.thumbsup.fill" : "lightbulb")
                .foregroundColor(.white)
            Text(feedback.message)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill((feedback.isPositive ? Color(hex: "8AC926") : Color(hex: "FB8500")))
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#if DEBUG
struct ShapeGardenGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ShapeGardenGameView(viewModel: ShapeGardenGameViewModel())
        }
    }
}
#endif
