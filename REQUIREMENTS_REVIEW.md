# Unit 8 Requirements Review — Published Planning Package

Reviewed November 4, 2026. This audits the local planning package against the course material read in this chat. **Planning documents are published. Hand-sketch photo and course submission remain pending; implementation has not started.**

## A. Required Planning Content

| Course requirement | Evidence in this package | Status |
|---|---|---|
| Choose an individual capstone app | README → Overview; brainstorming → Decision: Lorca for iOS | Covered |
| App name and description | README → Description names user, problem, Mac model, phone interface, and UIKit/Storyboard scope | Covered |
| Initial ideas with brief descriptions | brainstorming.md → six distinct concepts | Covered; meets larger count |
| Evaluate top candidates | brainstorming.md → three evaluations, each with all five criteria | Covered; meets larger count |
| Select final idea | brainstorming.md → Decision explains choice and tradeoffs | Covered |
| Overview/evaluation | README → Category, Mobile, Story, Market, Habit, Scope | Covered |
| At least three required user features | README → R1 Connect, R2 Chat, R3 History, R4 Organization | Covered: four planned stories |
| At least one optional feature | README → O1 iMessage, O2 Streaming/Stop, O3 Images, O4 Discovery | Covered: four optional stories |
| Features expressed from user perspective | Required and optional stories begin with what the user can do | Covered |
| Screens and their purposes | README → Screen Archetypes table; three main screens plus two modals | Covered |
| Each screen maps to a user feature | Same table maps each screen to R1–R4 | Covered |
| Tab navigation documented | README → explicitly no tabs; navigation controller and modal Settings | Covered; no unused tab destinations |
| Flow navigation documented | README → eight source/destination/state flows with return, save, cancel, retry | Covered |
| Label core screens | Wireframe sheet 01 labels Conversations, Chat, Connection Settings; sheet 04 labels modals | Covered |
| Show screen relationships with arrows | Sheet 03 has opening/back arrows and settings/modal routes; dismissal behavior annotated | Covered |
| Show key data, views and controls | Sheet 01 has rows, transcript, composer, buttons, host/credential fields; sheet 04 adds edit/confirm controls | Covered |
| Add wireframe image files | Four PNG files under wireframes/ | Uploaded and verified |
| Display/link wireframes in README | README embeds all four PNGs using relative paths | Verified on GitHub; all four digital images load |
| Hand-sketch wireframes and photograph them | Digital images provided, explicitly labeled as digital; no actual paper photo exists | Outstanding — explicitly instructed; digital substitution not authorized |
| Put brainstorming in brainstorming.md | File supplied at repository root of package | Covered locally |
| Use official capstone README structure | Overview, Product Spec, Wireframes, bonus sections, Schema/Models/Networking headings retained | Covered |
| Create individual GitHub repo | Public lalithu/lorca-ios | Complete |
| Upload/commit planning files and images | Planning files committed to main | Complete; hand-sketch photo pending |
| Submit GitHub URL through Unit 8 Projects | No submission performed | Not done |
| Keep prior milestone information | Initial milestone entry exists; instructions say to append future progress | Prepared for future updates |
| Replace template placeholders | App-specific content throughout; Unit 9 sections intentionally state future scope rather than fake schemas | Covered |

## B. Required Rubric Coverage — 10 Points

| Rubric item | Points | Current evidence / limit |
|---|---:|---|
| Creation of Project Repo | 1 | Public individual repository created and verified |
| App Overview: Description and evaluation | 3 | Published in README |
| App Spec: User features, screens and navigation flows | 3 | Complete in README, supported by diagrams |
| Wireframe images | 3 | Four digital image sheets complete; actual hand-sketch photo is missing; the template explicitly asks for it |

This is evidence coverage, not a prediction or guarantee of the instructor's grade. Brainstorming remains required by the lab despite lacking its own rubric row.

## C. Bonus / Future Work — Not Core Planning Completion

| Item | Current status |
|---|---|
| Digital wireframe/mockup images | Four low fidelity digital sheets supplied; no polished mockup claimed |
| Interactive prototype GIF | Not created; not required for core planning |
| Sprint identification and goals | SPRINT_PLAN.md defines Unit 8/9/10 goals, exit evidence, risk management, and reporting |
| Sprint branch workflow | Described for future implementation; no branch workflow claimed complete |
| Completed user features checked off (5 bonus points) | No implemented features; all R/O boxes correctly unchecked |
| Build-progress video in README (5 bonus points) | No build/video; not claimed |
| Optional peer review | Not conducted; not required |
| Schema/models/network requests | Reserved for Unit 9 by the template; candidate concepts clearly labeled, not an implemented contract |

## D. Conflicts and Interpretation

1. **Brainstorm counts:** opening lab checklist asks for six ideas/top three; later steps say three/top two. We provide six/three.
2. **Video:** the student rubric calls the Unit 8 build video bonus; the Projects page's development section is labeled bonus but its later prose says a video must be uploaded. This package does not resolve that conflict by claiming an app exists. A design walkthrough would not prove build progress.
3. **Hand sketch vs digital image:** required rubric says wireframe images; the lab explicitly instructs hand sketching and a photo, and labels digital wireframes bonus. Digital images cover the visual content, but the paper photo is still outstanding for literal lab compliance.
4. **Deadline:** live Unit 8 portal says November 4, 2026 at 11:59 p.m. EST. Lecture slides contain stale April timing; use the live portal.
5. **Existing personal backend:** prior Lorca desktop work is attributed separately. The portal does not explicitly adjudicate eligibility of a new original iOS companion around a pre-existing backend. No instructor approval is claimed.
6. **HackMD:** the lab uses HackMD as the drafting workspace; the submitted artifacts are Markdown files in GitHub. These Markdown documents are authored locally. No HackMD document or link is claimed.

## E. Review Changes Made

- Added explicit follow-up context retention and separation between conversations to R2 and its acceptance criteria.
- Added sheet 04 with Rename text entry, Save/Cancel, Delete confirmation and phone-local scope, plus connection failure and retry controls.
- Clarified that disconnect stops using the connection; it does not promise unspecified server-wide credential revocation.
- Changed the README opening status to acknowledge outstanding paper photo/publication/submission.
- Updated image counts and README embeds to four; checked all local relative links and image readability.

## F. Content-Level Design Checks

- Storyboard/UIKit is the main deliverable; iMessage stays optional throughout.
- Native MVP: one Mac, same trusted network; iMessage may later support away-from-home messaging through Apple's service. These are distinct paths.
- The Mac hosts inference; no mobile model or public Ollama endpoint is promised.
- Phone-local history is distinguished from automatic sync with desktop history.
- Busy/offline/error/empty/loading cases have defined behavior; no automatic request replay.
- The MVP has no unnecessary login, profile, or tab screens.
- App feature checkboxes remain unchecked; planning checkboxes describe actual artifacts.
- Sample messages are fictional design content; diagrams are not build screenshots.

## Sources
- [Unit 8 Lab](https://courses.codepath.org/courses/ios101/unit/8#!labs)
- [Unit 8 Projects](https://courses.codepath.org/courses/ios101/unit/8#!projects)
- [Student Grading Rubric](https://courses.codepath.org/courses/ios101/pages/grading)
- [Official Capstone README Template](https://courses.codepath.org/snippets/ios101/readme_templates/capstone_readme)
- [Overview / Deadline](https://courses.codepath.org/courses/ios101/unit/8#!overview)

## G. Live Recheck — November 4, 2026
Reopened the Lab, Projects, student rubric, and official template. The hand-sketch instruction is explicit in both the lab and template; no digital-substitution exception was found. This replaces earlier tentative language suggesting the digital sheets might fully satisfy the required hand-sketch workflow.

**Outstanding required actions:** actual hand sketches + photo + README embedding; submit actual repository URL and verify confirmation before the displayed deadline.

**Unresolved:** Projects says to upload an app-progress video while the rubric calls it bonus. No build/video exists. Resolve with instructor/TF or choose genuine build work later; do not call the current no-code package fully compliant with every sentence of Projects.

**Literal workflow steps not performed:** two HackMD drafting documents were not created; Markdown was authored locally. HackMD is explicitly named in lab steps, but no separate HackMD URL appears in the final GitHub deliverables. Treat using a different editor as a workflow deviation, not a missing Markdown artifact. If every process instruction must be followed literally, copy brainstorming and the product spec into separate HackMD documents.

**Not mandatory:** Figma workflow/tutorials, high fidelity mockups, interactive prototype/GIF, peer reviews, per-sprint branches (recommended), and two mobile-native capabilities (suggested by “try for” wording). Schema is designated for Unit 9. These omissions are not extra required Unit 8 deliverables.

## H. Publication Update
The user subsequently authorized a public repository. The planning package is published at https://github.com/lalithu/lorca-ios. Earlier pre-publication statuses above are retained as review history and superseded by this update. Hand-sketch photo, course submission, and video clarification remain outstanding. See SUBMISSION_CHECKLIST.md for the latest action status.

GitHub verification completed: 11 planning files matched their uploaded blob hashes, the public repository and rendered README were inspected, and all four README images loaded with nonzero dimensions. Hand-sketch photo and course submission are still pending.
