import SwiftUI

struct KindergartenGameLibrary {
    var games: [LearningGameDescriptor] {
        [shapeGardenDescriptor]
    }

    private var shapeGardenDescriptor: LearningGameDescriptor {
        LearningGameDescriptor(
            gradeLevel: .kindergarten,
            domain: .numeracy,
            focusSkills: [.shapeRecognition, .patterning, .listening],
            title: "Shape Garden",
            subtitle: "Match shapes to help the garden bloom with color.",
            estimatedMinutes: 5,
            iconSystemName: "leaf.fill",
            theme: .init(primaryHex: "FFB703", secondaryHex: "FB8500", accentHex: "219EBC"),
            destinationBuilder: {
                let viewModel = ShapeGardenGameViewModel()
                return AnyView(ShapeGardenGameView(viewModel: viewModel))
            }
        )
    }
}
