import SwiftUI

struct LearningGameDescriptor: Identifiable {
    struct Theme {
        let primaryHex: String
        let secondaryHex: String
        let accentHex: String
    }

    let id = UUID()
    let gradeLevel: GradeLevel
    let domain: CoreDomain
    let focusSkills: [KindergartenSkill]
    let title: String
    let subtitle: String
    let estimatedMinutes: Int
    let iconSystemName: String
    let theme: Theme
    let destinationBuilder: () -> AnyView
}
