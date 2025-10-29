# SeekO

SeekO is an iOS learning playground that delivers playful, curriculum-aligned mini adventures.  
This first milestone focuses on kindergarten with a Shape Garden game that reinforces shape recognition, listening, and patterning skills.

## Getting Started

1. Open Xcode 15+ and create a new **SwiftUI App** named `SeekO`.
2. Replace the generated files with the contents of the `SeekO/` folder in this repository.
3. Add the `Assets.xcassets` folder to the project (or replace the default one).
4. Build and run on the iOS 17 simulator or device.

> Tip: Keep the folder structure intact so files stay grouped by purpose (Scenes, GameEngine, Models, Components, Utilities, Resources).

## Current Kindergarten Experience

- **Shape Garden**: A matching game that prompts learners to spot shapes.  
  - Reinforces K-level standards for geometry recognition and listening comprehension.
  - Uses adaptive feedback and progress tracking to motivate repeated play.

## Project Structure

```
SeekO/
├─ SeekOApp.swift                # App entry point
├─ Scenes/                       # SwiftUI screens
│  ├─ RootView.swift             # Grade selection hub
│  └─ Kindergarten/              # Kindergarten-only experiences
├─ GameEngine/                   # Game orchestration logic
│  ├─ GameManager.swift
│  └─ Kindergarten/ShapeGardenGameViewModel.swift
├─ Models/                       # Curriculum & data models
├─ Components/                   # Reusable SwiftUI components
├─ Utilities/                    # Helpers (Color extensions, etc.)
└─ Assets.xcassets/              # Visual assets placeholder
```

## Next Steps

1. **Add more kindergarten adventures**  
   - Letter garden (phonics), counting carnival (numbers 1–20), pattern parade (AB/ABC patterns).
2. **Curriculum mapping**  
   - Document each activity's standard in `Resources/` for teachers and parents.
3. **Reward system**  
   - Persist badges/stickers in `GameManager` to celebrate milestones.
4. **Accessibility polish**  
   - VoiceOver hints, haptic feedback, dynamic type, and color-blind friendly palettes.
5. **K-12 roadmap**  
   - Extend the `GameManager` catalog for additional grades; reuse component architecture.

Feel free to reach out with the grade level you'd like to unlock next! 🎉
