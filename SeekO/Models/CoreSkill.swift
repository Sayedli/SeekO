import Foundation

enum CoreDomain: String, CaseIterable, Identifiable {
    case literacy = "Literacy"
    case numeracy = "Numeracy"
    case socialEmotional = "Social & Emotional"
    case science = "Science"
    case arts = "Creative Arts"

    var id: String { rawValue }
}

enum KindergartenSkill: String, CaseIterable, Identifiable {
    case letterRecognition = "Letter Recognition"
    case phonemicAwareness = "Phonemic Awareness"
    case counting = "Counting"
    case shapeRecognition = "Shape Recognition"
    case patterning = "Patterning"
    case motorSkills = "Fine Motor Skills"
    case listening = "Active Listening"

    var id: String { rawValue }
}
