import Foundation
import Combine
import AVFoundation

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
    private var currentPromptLetter: Letter?

    private let speechSynthesizer = AVSpeechSynthesizer()
    private let narratorVoice: AVSpeechSynthesisVoice? = {
        let preferredVoices = [
            "com.apple.ttsbundle.Samantha-compact",
            "com.apple.ttsbundle.Ava-compact",
            "com.apple.ttsbundle.Karen-compact"
        ]
        for identifier in preferredVoices {
            if let match = AVSpeechSynthesisVoice(identifier: identifier) {
                return match
            }
        }
        if let australian = AVSpeechSynthesisVoice(language: "en-AU") {
            return australian
        }
        if let us = AVSpeechSynthesisVoice(language: "en-US") {
            return us
        }
        return nil
    }()
    private var isAudioEnabled = false

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
            speakFeedback(for: answer.letter, positive: true)
            prepareNextRound()
        } else {
            feedback = Feedback(
                message: "Almost! Say the sound /\(answer.letter.phoneme)/ and try again.",
                isPositive: false
            )
            speakFeedback(for: answer.letter, positive: false)
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
            currentPromptLetter = nil
            speak(text: "Alphabet superstar! You matched \(score) letter sounds. Keep practicing every day!")
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
        currentPromptLetter = correctLetter

        if let answer = currentAnswer {
            promptText = "Which letter starts the word \(answer.letter.keyword.capitalized)?"
            helperText = "Listen for the /\(answer.letter.phoneme)/ sound."
            speakPrompt(for: answer.letter)
        } else {
            promptText = "Tap the letter that matches the sound."
            helperText = "Listen carefully and choose the best match."
            speak(text: "Tap the matching letter. Listen to the sound and pick the correct letter.")
        }
    }

    func replayPromptAudio() {
        guard isAudioEnabled, let letter = currentPromptLetter else { return }
        speakPrompt(for: letter)
    }

    func enableAudioPrompts() {
        guard !isAudioEnabled else {
            replayPromptAudio()
            return
        }
        isAudioEnabled = true
        replayPromptAudio()
    }

    func disableAudioPrompts() {
        isAudioEnabled = false
        DispatchQueue.main.async {
            self.speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }

    private func speakPrompt(for letter: Letter) {
        let prompt = "Which letter starts the word \(letter.keyword)?"
        let helper = "Listen for the \(letter.phonemeSpeech) sound."
        speak(text: "\(prompt) \(helper)")
    }

    private func speakFeedback(for letter: Letter, positive: Bool) {
        if positive {
            speak(text: "Great work! \(letter.uppercase) says \(letter.phonemeSpeech) like in \(letter.keyword).")
        } else {
            speak(text: "Almost. Say \(letter.phonemeSpeech) and try again.")
        }
    }

    private func speak(text: String) {
        guard isAudioEnabled else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = narratorVoice
        utterance.rate = 0.46
        utterance.pitchMultiplier = 1.08
        utterance.postUtteranceDelay = 0.15
        DispatchQueue.main.async {
            self.speechSynthesizer.stopSpeaking(at: .immediate)
            self.speechSynthesizer.speak(utterance)
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

private extension LetterGardenGameViewModel.Letter {
    var phonemeSpeech: String {
        switch phoneme {
        case "a": return "aah"
        case "e": return "eh"
        case "i": return "ih"
        case "o": return "ah"
        case "u": return "uh"
        case "kw": return "kwuh"
        case "z": return "zzz"
        default: return phoneme
        }
    }
}
