import SwiftUI

struct KindergartenHubView: View {
    @EnvironmentObject private var gameManager: GameManager

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
                .overlay(jungleOverlay)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    introSection

                    junglePrompt

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
                .padding(.horizontal)
                .padding(.vertical, 32)
            }
        }
        .navigationTitle("Kindergarten")
        .navigationBarTitleDisplayMode(.large)
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "0B3D2E"),
                Color(hex: "135F3A"),
                Color(hex: "1B8B4D")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var jungleOverlay: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 220)
                .blur(radius: 60)
                .offset(x: -160, y: -260)
            Circle()
                .fill(Color(hex: "F8E16C").opacity(0.08))
                .frame(width: 260)
                .blur(radius: 70)
                .offset(x: 140, y: -220)
            Circle()
                .fill(Color(hex: "5EEAD4").opacity(0.12))
                .frame(width: 320)
                .blur(radius: 90)
                .offset(x: 120, y: 240)
        }
    }

    private var introSection: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 36)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "22C55E"),
                            Color(hex: "16A34A"),
                            Color(hex: "0D7040")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    JungleCanopyShape()
                        .stroke(Color.white.opacity(0.12), lineWidth: 1.5)
                        .blur(radius: 0.5)
                        .padding(20)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 24, x: 0, y: 18)

            VStack(alignment: .leading, spacing: 16) {
                Label {
                    Text("Welcome to the Jungle Classroom")
                        .font(.title.bold())
                        .foregroundColor(.white)
                } icon: {
                    Image(systemName: "leaf.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "FDE68A"))
                }

                Text("Swing through playful quests that build core kindergarten skills with songs, stories, and friendly animal guides.")
                    .font(.callout)
                    .foregroundColor(Color.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 12) {
                    JungleBadge(icon: "music.note.list", label: "Rhythmic prompts")
                    JungleBadge(icon: "sparkles", label: "Adaptive feedback")
                }
            }
            .padding(28)
        }
    }

    private var junglePrompt: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Choose a jungle mission")
                    .font(.headline)
                    .foregroundColor(Color.white.opacity(0.92))
                Text("Each adventure is designed for a quick 5-minute burst of joyful practice.")
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.7))
            }

            Spacer()

            Image(systemName: "tortoise.fill")
                .font(.system(size: 34))
                .foregroundColor(Color(hex: "FDE68A"))
                .padding(12)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.15))
                )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white.opacity(0.1))
        )
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
        .preferredColorScheme(.dark)
    }
}
#endif

private struct JungleBadge: View {
    let icon: String
    let label: String

    var body: some View {
        Label {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(Color(hex: "FDE68A"))
        } icon: {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(Color(hex: "FDE68A"))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.18))
        )
    }
}

private struct JungleCanopyShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let height = rect.height
        let width = rect.width
        let waveHeight: CGFloat = height * 0.18
        let step = width / 6

        path.move(to: CGPoint(x: 0, y: height * 0.2))

        for index in 0...6 {
            let x = CGFloat(index) * step
            let controlY = (index % 2 == 0) ? waveHeight : waveHeight * 0.4
            path.addQuadCurve(
                to: CGPoint(x: min(x + step, width), y: height * 0.2),
                control: CGPoint(x: x + step / 2, y: controlY)
            )
        }

        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        return path
    }
}
