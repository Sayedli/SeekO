import Foundation

enum GradeLevel: String, CaseIterable, Identifiable {
    case kindergarten = "Kindergarten"
    case grade1 = "Grade 1"
    case grade2 = "Grade 2"
    case grade3 = "Grade 3"
    case grade4 = "Grade 4"
    case grade5 = "Grade 5"
    case grade6 = "Grade 6"
    case grade7 = "Grade 7"
    case grade8 = "Grade 8"
    case grade9 = "Grade 9"
    case grade10 = "Grade 10"
    case grade11 = "Grade 11"
    case grade12 = "Grade 12"

    var id: String { rawValue }
}
