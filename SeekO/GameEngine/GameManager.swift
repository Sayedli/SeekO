import SwiftUI
import Combine

final class GameManager: ObservableObject {
    @Published var activeGrade: GradeLevel = .kindergarten
    @Published private(set) var kindergartenGames: [LearningGameDescriptor] = []
    @Published var activeGame: LearningGameDescriptor?

    private let kindergartenLibrary = KindergartenGameLibrary()

    init() {
        reloadCatalog()
    }

    func reloadCatalog() {
        kindergartenGames = kindergartenLibrary.games
    }

    func launch(game: LearningGameDescriptor) {
        activeGame = game
    }

    func resetActiveGame() {
        activeGame = nil
    }
}
