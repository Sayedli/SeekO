import SwiftUI

struct RootView: View {
    @EnvironmentObject private var gameManager: GameManager

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                    .overlay(OrbitalGlowOverlay())

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 32) {
                        heroSection
                        gradeSection
                    }
                    .padding(.vertical, 48)
                    .padding(.horizontal, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Color.clear.frame(height: 0)
                }
            }
        }
    }

    private var heroSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "0F172A"), Color(hex: "164E63"), Color(hex: "0B7285")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 36)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1.5)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 28, x: 0, y: 24)

            VStack(spacing: 20) {
                Text("SeekO")
                    .font(.system(size: 54, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "FACC15"), Color(hex: "F97316")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(hex: "FACC15").opacity(0.4), radius: 12, x: 0, y: 4)

                Text("Seek Omniscience.\nIn the name of Allah, the Beneficent, the Merciful")
                    .font(.title3.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.white.opacity(0.92))

                Divider()
                    .frame(width: 120)
                    .overlay(Color.white.opacity(0.3))

                Text("Begin your journey with adventures crafted for curious kindergarten minds.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.white.opacity(0.75))
            }
            .padding(.vertical, 48)
            .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
    }

    private var gradeSection: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Begin your jungle classroom quest")
                .font(.title2.weight(.bold))
                .foregroundColor(Color(hex: "ECFEFF"))
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)

            NavigationLink {
                KindergartenHubView()
                    .environmentObject(gameManager)
            } label: {
                GradeCardView(
                    gradeLevel: .kindergarten,
                    numberOfGames: gameManager.kindergartenGames.count,
                    accentHex: "14B8A6"
                )
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "022C43"),
                Color(hex: "053047"),
                Color(hex: "0B3D52")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

private struct GradeCardView: View {
    let gradeLevel: GradeLevel
    let numberOfGames: Int
    let accentHex: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: accentHex),
                            Color(hex: "0EA5E9"),
                            Color(hex: "1D4ED8")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color(hex: accentHex).opacity(0.3), radius: 20, x: 0, y: 12)

            VStack(alignment: .leading, spacing: 14) {
                Label {
                    Text(gradeLevel.rawValue)
                        .font(.title3.weight(.black))
                        .foregroundColor(.white)
                } icon: {
                    Image(systemName: "leaf.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "FACC15"))
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }

                Text("\(numberOfGames) interactive adventures ready to play.")
                    .font(.callout)
                    .foregroundColor(Color.white.opacity(0.85))

                HStack(spacing: 12) {
                    JunglePip(icon: "sparkles", label: "Story-guided")
                    JunglePip(icon: "music.note", label: "Voice-led")
                }
            }
            .padding(28)

            HStack {
                Spacer()
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(Color.white.opacity(0.95))
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 6)
            }
            .padding(28)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white.opacity(0.16), lineWidth: 1.5)
        )
        .frame(maxWidth: .infinity)
    }
}

private struct JunglePip: View {
    let icon: String
    let label: String

    var body: some View {
        Label {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(Color.white.opacity(0.92))
        } icon: {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(Color(hex: "FACC15"))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.18))
        )
    }
}

private struct OrbitalGlowOverlay: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "FACC15").opacity(0.14))
                .frame(width: 300)
                .blur(radius: 120)
                .offset(x: -140, y: -280)
            Circle()
                .fill(Color(hex: "22D3EE").opacity(0.18))
                .frame(width: 340)
                .blur(radius: 110)
                .offset(x: 180, y: -140)
            Circle()
                .fill(Color(hex: "F97316").opacity(0.12))
                .frame(width: 320)
                .blur(radius: 140)
                .offset(x: -40, y: 260)
        }
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
