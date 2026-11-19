# Capstone requirement review — November 18, 2026

Based on the Unit 8/9 overview, lab and project screenshots/text supplied by the student, plus Andros Slowley's final-submission email. Milestone 1 is already submitted; its artifacts are preserved. This review does not claim access to an unseen final rubric or guarantee points.

| Requirement | Evidence / current state |
| --- | --- |
| UIKit and Storyboard (student's course constraint) | `ios/LorcaIOS/Base.lproj/Main.storyboard`, native controllers, navigation and Auto Layout; no SwiftUI imports. |
| At least 3 required + 1 optional feature | Current README: R1–R4 notes/persistence, connection, inline help and organization; O1 checkable lists plus screenshot OCR and research. |
| App overview/evaluation | Current README describes the revised product; original Mobile/Story/Market/Habit/Scope evaluation in `docs/milestone-1.md`. |
| Feature, screen and navigation specification | Current README and flow diagram; three core Storyboard screens. No mandatory tab bar appears in the supplied instructions. |
| Brainstorming and hand sketches | Existing `brainstorming.md` and `wireframes/hand-sketch-main.jpg` retained. |
| Supporting documents / flowcharts | README, SPRINT_PLAN, implementation guide, video guide, preserved planning and wireframe sheets. |
| Updated sprint / completed feature checkboxes | README and current section of SPRINT_PLAN. |
| Buildable downloadable Xcode project | `ios/LorcaIOS.xcodeproj`, shared LorcaIOS scheme, source/assets/storyboard/plist, no third-party packages. Simulator setup in README. |
| New video above old videos; preserve old video | [New capstone demo](https://www.youtube.com/watch?v=OmjLkg07w2c) appears above both preserved earlier videos in README. |
| Submit GitHub repo on Canvas | **Pending student action**; instructor email specifies Canvas. Unit 9 page also has a CodePath Submit entry to check. |
| Instructor GitHub access: aslowle1 | Repository is public; unauthenticated read access is available without an invitation. |
| Deadline | Supplied Unit 9 page: November 18, 2026, 11:59 p.m. EST; instructor email says midnight tonight. |
| Bonus digital wireframes | Four existing PNG sheets included; award is instructor's decision. |
| Bonus interactive prototype GIF | Not created or claimed; optional in the supplied Unit 8 material. |

## Scope revision

The former chat/pairing specification remains historical, not a claim that every original stretch feature shipped. The final product is a notes-first app evaluated in Simulator. Direct localhost Ollama replaces the proposed authenticated physical-phone adapter. iMessage, streaming, automatic discovery, full image captioning, calendar export and desktop synchronization are not marked complete.

The required/optional lists are the student's app specification, not a universal course-mandated list of specific app capabilities. Changing that specification is documented explicitly.

## Verification and limits

- Xcode Simulator builds succeeded, most recently after the cursor/footer fixes.
- Real local `qwen3:14b` flow passed: connection, authored-text preservation, generated inline content, progress cue appearing/clearing, and saved note reopening after relaunch.
- Focused cursor flow passed after the tap fix: initial editing focus, Done dismisses, tapping the empty canvas restores editing; the exported screenshot shows the blue caret.
- Canvas/list navigation was checked during layout work. A later combined preview encountered a navigation-timing failure; the isolated cursor flow was then checked successfully. No claim that every UI path is exhaustively tested.
- Checklists, rename/delete, screenshot OCR and research are implemented. The video should demonstrate checklists and organization as observable acceptance evidence; broad failure/orientation/accessibility/device tests were not run.
- Native glass is available on iOS 26+; visual testing used iOS 18. No physical-device check is claimed or required for the agreed Simulator submission.

## Outstanding before submission

The student recorded and uploaded the new demo; its link is above the old videos. Submit the repo/video and confirm receipt. Submission itself is not completed by packaging source.

## Supplied course references

- [Unit 8 lab](https://courses.codepath.org/courses/ios101/unit/8#!labs)
- [Unit 8 projects](https://courses.codepath.org/courses/ios101/unit/8#!projects)
- [Unit 9 lab](https://courses.codepath.org/courses/ios101/unit/9#!labs)
- [Unit 9 projects](https://courses.codepath.org/courses/ios101/unit/9#!projects)

[Preserved Unit 8 review](docs/milestone-1-requirements.md) · [Original submission notes](docs/milestone-1-submission.md)
