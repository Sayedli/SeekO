import SwiftUI

struct RootView: View {
    @EnvironmentObject private var gameManager: GameManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    header
                    gradeSection
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("SeekO")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Learn through play")
                .font(.largeTitle.bold())
            Text("Interactive adventures that follow the K‑12 curriculum. Start exploring with our kindergarten games.")
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }

    private var gradeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose a starting grade")
                .font(.title2.weight(.semibold))

            NavigationLink {
                KindergartenHubView()
                    .environmentObject(gameManager)
            } label: {
                GradeCardView(
                    gradeLevel: .kindergarten,
                    numberOfGames: gameManager.kindergartenGames.count,
                    accentHex: "8ECAE6"
                )
            }
            .buttonStyle(.plain)
        }
    }
}

private struct GradeCardView: View {
    let gradeLevel: GradeLevel
    let numberOfGames: Int
    let accentHex: String

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(gradeLevel.rawValue)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                Text("\(numberOfGames) interactive adventures ready to play.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
            }

            Spacer()

            Image(systemName: "play.circle.fill")
                .font(.system(size: 42))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color(hex: accentHex), Color(hex: "219EBC")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(24)
        .shadow(color: Color(hex: accentHex).opacity(0.22), radius: 12, x: 0, y: 6)
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(GameManager())
    }
}
#endif
