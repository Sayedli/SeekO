import SwiftUI

struct KindergartenHubView: View {
    @EnvironmentObject private var gameManager: GameManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                introSection

                VStack(spacing: 20) {
                    ForEach(gameManager.kindergartenGames) { game in
                        NavigationLink {
                            game.destinationBuilder()
                                .navigationTitle(game.title)
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        ProgressBadge(minutes: game.estimatedMinutes)
                                    }
                                }
                        } label: {
                            GameCardView(game: game)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Kindergarten")
        .navigationBarTitleDisplayMode(.large)
    }

    private var introSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Playful learning journeys")
                .font(.title.bold())
            Text("Each activity is crafted to meet early childhood learning standards while keeping the experience playful and hands-on.")
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }
}

private struct ProgressBadge: View {
    let minutes: Int

    var body: some View {
        Label {
            Text("\(minutes) min")
                .font(.subheadline.weight(.semibold))
        } icon: {
            Image(systemName: "hourglass")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color.blue.opacity(0.15)))
    }
}

#if DEBUG
struct KindergartenHubView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            KindergartenHubView()
                .environmentObject(GameManager())
        }
    }
}
#endif
