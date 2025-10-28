import Foundation

final class ShapeGardenGameViewModel: ObservableObject {
    struct ShapeCard: Identifiable, Equatable {
        let id = UUID()
        let type: ShapeType
        let colorHex: String

        static func == (lhs: ShapeCard, rhs: ShapeCard) -> Bool {
            lhs.type == rhs.type
        }
    }

    struct Feedback {
        let message: String
        let isPositive: Bool
    }

    enum ShapeType: CaseIterable {
        case circle, square, triangle, diamond, star, heart

        var displayName: String {
            switch self {
            case .circle: return "circle"
            case .square: return "square"
            case .triangle: return "triangle"
            case .diamond: return "diamond"
            case .star: return "star"
            case .heart: return "heart"
            }
        }

        var systemImageName: String {
            switch self {
            case .circle: return "circle.fill"
            case .square: return "square.fill"
            case .triangle: return "triangle.fill"
            case .diamond: return "diamond.fill"
            case .star: return "star.fill"
            case .heart: return "heart.fill"
            }
        }
    }

    @Published private(set) var promptText: String = ""
    @Published private(set) var choices: [ShapeCard] = []
    @Published private(set) var feedback: Feedback?
    @Published private(set) var roundNumber: Int = 0
    @Published private(set) var score: Int = 0
    @Published private(set) var isComplete: Bool = false

    private let totalRounds = 6
    private var currentAnswer: ShapeCard?

    init() {
        startGame()
    }

    var progress: Double {
        guard totalRounds > 0 else { return 0 }
        return Double(roundNumber) / Double(totalRounds)
    }

    func startGame() {
        score = 0
        roundNumber = 0
        isComplete = false
        feedback = nil
        prepareNextRound()
    }

    func select(card: ShapeCard) {
        guard !isComplete else { return }
        guard let answer = currentAnswer else { return }

        if card == answer {
            score += 1
            feedback = Feedback(message: successMessage(for: score), isPositive: true)
            prepareNextRound()
        } else {
            feedback = Feedback(message: "Try again! Look closely at the shapes.", isPositive: false)
        }
    }

    private func prepareNextRound() {
        roundNumber += 1
        if roundNumber > totalRounds {
            roundNumber = totalRounds
            isComplete = true
            promptText = "Great job!"
            return
        }

        let availableShapes = ShapeType.allCases.shuffled()
        let correctType = availableShapes.first ?? .circle
        let candidateTypes = Array(availableShapes.prefix(3))

        choices = candidateTypes.map { type in
            ShapeCard(type: type, colorHex: colorHex(for: type))
        }.shuffled()

        if let matching = choices.first(where: { $0.type == correctType }) {
            currentAnswer = matching
        } else if let fallback = choices.first {
            currentAnswer = fallback
        }

        if let answer = currentAnswer {
            promptText = "Can you find the \(answer.type.displayName)?"
        } else {
            promptText = "Pick the matching shape!"
        }
    }

    private func successMessage(for score: Int) -> String {
        switch score {
        case 0...2: return "Nice! The garden is sprouting."
        case 3...4: return "Great work! Flowers are blooming."
        default: return "Amazing! The whole garden is colorful."
        }
    }

    private func colorHex(for type: ShapeType) -> String {
        switch type {
        case .circle: return "FF595E"
        case .square: return "1982C4"
        case .triangle: return "8AC926"
        case .diamond: return "FFCA3A"
        case .star: return "6A4C93"
        case .heart: return "FF006E"
        }
    }
}
