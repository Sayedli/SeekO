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
            theme: .init(primaryHex: "1C7C54", secondaryHex: "2FB573", accentHex: "FACC15"),
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
            theme: .init(primaryHex: "0A5E33", secondaryHex: "16A34A", accentHex: "FDE68A"),
            destinationBuilder: {
                let viewModel = ShapeGardenGameViewModel()
                return AnyView(ShapeGardenGameView(viewModel: viewModel))
            }
        )
    }
}
