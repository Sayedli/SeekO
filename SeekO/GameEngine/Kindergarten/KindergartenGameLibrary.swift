import SwiftUI

struct KindergartenGameLibrary {
    var games: [LearningGameDescriptor] {
        [letterGardenDescriptor, shapeGardenDescriptor]
    }

    private var letterGardenDescriptor: LearningGameDescriptor {
        LearningGameDescriptor(
            gradeLevel: .kindergarten,
            domain: .literacy,
            focusSkills: [.letterRecognition, .phonemicAwareness, .listening],
            title: "Letter Garden",
            subtitle: "Match letters with their sounds to help the garden sing.",
            estimatedMinutes: 5,
            iconSystemName: "textformat.abc",
            theme: .init(primaryHex: "9C27B0", secondaryHex: "F48FB1", accentHex: "8BC34A"),
            destinationBuilder: {
                let viewModel = LetterGardenGameViewModel()
                return AnyView(LetterGardenGameView(viewModel: viewModel))
            }
        )
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
