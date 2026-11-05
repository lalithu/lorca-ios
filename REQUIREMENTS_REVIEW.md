# Unit 8 Requirements Review — Current State

## Current Result
The original planning milestone was submitted successfully with 4 hours and a planning walkthrough. A working basic UIKit/Storyboard prototype has since been added. The student will submit the updated build demo personally. No second submission is claimed.

## Required Planning Coverage
| Requirement | Evidence | Status |
|---|---|---|
| Six initial concepts | brainstorming.md | Complete |
| Top-three evaluations using Mobile, Story, Market, Habit, Scope | brainstorming.md | Complete |
| Final app choice and rationale | brainstorming.md | Complete |
| App name, description, category and evaluation | README Overview | Complete |
| At least three required and one optional user story | Four required, four optional | Complete |
| Screens, purposes, and story mapping | README Screen Archetypes | Complete |
| Tab and flow navigation documented | No tabs; navigation controller and modal Settings; named flows | Complete |
| Hand sketch, photograph, upload, README embedding | wireframes/hand-sketch-main.jpg | Complete |
| Digital screen/control/navigation visuals | Four PNG sheets | Included as supplemental designs |
| GitHub repo and committed deliverables | lalithu/lorca-ios | Complete |
| Original course submission | CodePath displayed receipt confirmation | Complete |
| Updated build-demo resubmission | Student handles; new URL not supplied here yet | Pending |

## Actual Build Progress
- [x] UIKit/Storyboard app, Xcode project and 🫍 app icon.
- [x] Conversations, Chat, and modal Connection Settings scenes.
- [x] New conversation and navigation to Chat.
- [x] Locally saved draft restored across app restart.
- [x] Settings opens, saves a Mac address locally, and returns home.
- [ ] Live Mac/Ollama connection, pairing and real responses.
- [ ] Complete MVP acceptance for all R1–R4 requirements.

Rename/Delete are implemented in source but not fully exercised in this short verification pass. Full MVP checkboxes remain unchecked. Saved address does not mean connected; draft does not mean sent.

## Verification
Xcode 27 Simulator build succeeded. Final app launched on iPhone 18 Pro / iOS 27. Basic navigation, draft persistence across restart, and local settings save were observed. The initial iOS 27 scene-lifecycle launch problem was corrected with SceneDelegate/window initialization. No broad edge-case, accessibility, orientation, or device-size test suite is claimed.

## Clarifications
- Six ideas/three evaluations satisfy the larger counts in the lab despite its smaller counts later in the body.
- Actual student hand sketch is included; digital images are supplemental.
- Original planning video is historical evidence. New video should demonstrate the running app.
- Unit 8 rubric labels build-video work bonus; Projects also uses mandatory wording. The working app/demo addresses that concern without claiming a finished app.
- No interactive Figma prototype/GIF is claimed; it is optional.
- Schema/networking details belong to Unit 9.
- Existing Lorca desktop work is attributed; the iOS prototype is new capstone work.
- HackMD drafting was replaced with local Markdown. The required final files exist; no separate HackMD document is claimed.

## Sources
- [Unit 8 Lab](https://courses.codepath.org/courses/ios101/unit/8#!labs)
- [Unit 8 Projects](https://courses.codepath.org/courses/ios101/unit/8#!projects)
- [Grading rubric](https://courses.codepath.org/courses/ios101/pages/grading)
- [Capstone README template](https://courses.codepath.org/snippets/ios101/readme_templates/capstone_readme)
