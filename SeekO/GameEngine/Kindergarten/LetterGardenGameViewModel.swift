import Foundation
import Combine

final class LetterGardenGameViewModel: ObservableObject {
    struct LetterCard: Identifiable, Equatable {
        let id = UUID()
        let letter: Letter

        static func == (lhs: LetterCard, rhs: LetterCard) -> Bool {
            lhs.letter.character == rhs.letter.character
        }
    }

    struct Letter: Hashable {
        let character: Character
        let keyword: String
        let phoneme: String

        var uppercase: String { String(character) }
        var lowercase: String { uppercase.lowercased() }
        var displayDescription: String {
            "\(uppercase) as in \(keyword)"
        }
    }

    struct Feedback {
        let message: String
        let isPositive: Bool
    }

    @Published private(set) var promptText: String = ""
    @Published private(set) var helperText: String = ""
    @Published private(set) var choices: [LetterCard] = []
    @Published private(set) var feedback: Feedback?
    @Published private(set) var roundNumber: Int = 0
    @Published private(set) var score: Int = 0
    @Published private(set) var isComplete: Bool = false

    private let totalRounds = 6
    private var currentAnswer: LetterCard?
    private var letterBag: [Letter] = LetterGardenGameViewModel.letterDeck.shuffled()

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
        letterBag = Self.letterDeck.shuffled()
        prepareNextRound()
    }

    func select(card: LetterCard) {
        guard !isComplete else { return }
        guard let answer = currentAnswer else { return }

        if card == answer {
            score += 1
            feedback = Feedback(
                message: "Nice! \(answer.letter.displayDescription) makes the /\(answer.letter.phoneme)/ sound.",
                isPositive: true
            )
            prepareNextRound()
        } else {
            feedback = Feedback(
                message: "Almost! Say the sound /\(answer.letter.phoneme)/ and try again.",
                isPositive: false
            )
        }
    }

    private func prepareNextRound() {
        roundNumber += 1
        guard roundNumber <= totalRounds else {
            roundNumber = totalRounds
            isComplete = true
            promptText = "Alphabet superstar!"
            helperText = "You matched \(score) letter sounds. Keep practicing every day!"
            currentAnswer = nil
            return
        }

        if letterBag.count < 4 {
            letterBag = Self.letterDeck.shuffled()
        }

        let correctLetter = letterBag.removeFirst()
        let distractors = letterBag.prefix(3)
        let pool = ([correctLetter] + distractors).shuffled()

        choices = pool.map { LetterCard(letter: $0) }.shuffled()
        currentAnswer = choices.first(where: { $0.letter == correctLetter })

        if let answer = currentAnswer {
            promptText = "Find the letter \(answer.letter.uppercase)."
            helperText = "It says /\(answer.letter.phoneme)/ like in \(answer.letter.keyword)."
        } else {
            promptText = "Tap the matching letter."
            helperText = "Listen to the sound and pick the correct letter."
        }
    }
}

extension LetterGardenGameViewModel {
    static let letterDeck: [Letter] = [
        Letter(character: "A", keyword: "apple", phoneme: "a"),
        Letter(character: "B", keyword: "ball", phoneme: "b"),
        Letter(character: "C", keyword: "cat", phoneme: "k"),
        Letter(character: "D", keyword: "drum", phoneme: "d"),
        Letter(character: "E", keyword: "elephant", phoneme: "e"),
        Letter(character: "F", keyword: "fish", phoneme: "f"),
        Letter(character: "G", keyword: "goat", phoneme: "g"),
        Letter(character: "H", keyword: "hat", phoneme: "h"),
        Letter(character: "I", keyword: "igloo", phoneme: "i"),
        Letter(character: "J", keyword: "jam", phoneme: "j"),
        Letter(character: "K", keyword: "kite", phoneme: "k"),
        Letter(character: "L", keyword: "lion", phoneme: "l"),
        Letter(character: "M", keyword: "moon", phoneme: "m"),
        Letter(character: "N", keyword: "nest", phoneme: "n"),
        Letter(character: "O", keyword: "octopus", phoneme: "o"),
        Letter(character: "P", keyword: "pig", phoneme: "p"),
        Letter(character: "Q", keyword: "queen", phoneme: "kw"),
        Letter(character: "R", keyword: "rainbow", phoneme: "r"),
        Letter(character: "S", keyword: "sun", phoneme: "s"),
        Letter(character: "T", keyword: "turtle", phoneme: "t"),
        Letter(character: "U", keyword: "umbrella", phoneme: "u"),
        Letter(character: "V", keyword: "violin", phoneme: "v"),
        Letter(character: "W", keyword: "whale", phoneme: "w"),
        Letter(character: "X", keyword: "xylophone", phoneme: "z"),
        Letter(character: "Y", keyword: "yarn", phoneme: "y"),
        Letter(character: "Z", keyword: "zebra", phoneme: "z")
    ]
}
