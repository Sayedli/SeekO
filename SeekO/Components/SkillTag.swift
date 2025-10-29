import SwiftUI

struct SkillTag: View {
    let label: String
    let backgroundHex: String

    var body: some View {
        Text(label)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color(hex: backgroundHex).opacity(0.18))
            )
            .foregroundColor(Color(hex: backgroundHex).opacity(0.9))
    }
}

#if DEBUG
struct SkillTag_Previews: PreviewProvider {
    static var previews: some View {
        SkillTag(label: "Shape Recognition", backgroundHex: "219EBC")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
