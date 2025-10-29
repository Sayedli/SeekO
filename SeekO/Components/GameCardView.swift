import SwiftUI

struct GameCardView: View {
    let game: LearningGameDescriptor

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: game.iconSystemName)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(16)
                    .background(
                        Circle()
                            .fill(Color(hex: game.theme.accentHex).opacity(0.28))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(game.title)
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)
                    Text(game.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            HStack(spacing: 8) {
                Label("\(game.estimatedMinutes) min", systemImage: "clock")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.9))

                Spacer()
            }

            HStack(spacing: 6) {
                ForEach(game.focusSkills.prefix(2), id: \.id) { skill in
                    SkillTag(label: skill.rawValue, backgroundHex: game.theme.accentHex)
                }

                if game.focusSkills.count > 2 {
                    SkillTag(label: "+\(game.focusSkills.count - 2) more", backgroundHex: game.theme.secondaryHex)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color(hex: game.theme.primaryHex),
                    Color(hex: game.theme.secondaryHex)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(24)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: Color(hex: game.theme.primaryHex).opacity(0.25), radius: 12, x: 0, y: 8)
    }
}

#if DEBUG
struct GameCardView_Previews: PreviewProvider {
    static var previews: some View {
        GameCardView(
            game: LearningGameDescriptor(
                gradeLevel: .kindergarten,
                domain: .numeracy,
                focusSkills: [.shapeRecognition, .patterning],
                title: "Shape Garden",
                subtitle: "Match shapes to help the garden bloom with color.",
                estimatedMinutes: 5,
                iconSystemName: "leaf.fill",
                theme: .init(primaryHex: "FFB703", secondaryHex: "FB8500", accentHex: "219EBC"),
                destinationBuilder: { AnyView(Text("Game")) }
            )
        )
        .padding()
        .previewLayout(.sizeThatFits)
        .background(Color.black)
    }
}
#endif
