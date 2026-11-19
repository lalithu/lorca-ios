# Milestone 2 video

**Recorded demo:** [Watch on YouTube](https://www.youtube.com/watch?v=OmjLkg07w2c) — approximately 8 minutes. The outline below was a recording aid, not a required duration.

Before recording: run Ollama, install/select the model, open the app in Simulator, and keep the model warm. Use **File → Open Simulator** in Xcode if necessary. No physical phone is needed.

1. **Build and connect (20 seconds).** Show Xcode's `Main.storyboard` briefly and say “UIKit and Storyboard.” Run in Simulator. Open the gear; show localhost, the installed model and **Test & Connect → Connected**. Return with Done.
2. **Real inline help (45–60 seconds).** New note. Type `Study guide for counting and permutations:` and `Explain factorials and give two short worked examples.` Pause. Show the pulsing passage dots, then the real blue response below your original text. Briefly edit a response; show the amber edit/blue removal, then Undo. Tap Model following and show Pause/Resume.
3. **Optional feature (30 seconds).** New note. Type `Things to do:` followed by `Buy groceries`, `Email my professor`, and `Finish the capstone video`, each on its own line. After the model produces checkboxes, check one and show it move to the bottom. Your original writing stays above.
4. **Saved notes and organization (30 seconds).** Open the upper-left saved-notes icon. Search for a note; clear search; swipe a row to Rename. Show Delete → Cancel so the note remains. Reopen it.
5. **Persistence (15 seconds).** Stop and run the app again from Xcode; show the saved note reopening. Say “Notes save locally in Simulator. The model runs on this Mac through Ollama.”

Keep waiting time brief or trim it in the recording; the response shown must be real. Screenshot import and research are extra demonstrations, not necessary to meet the one-optional-feature requirement. No prescribed video duration was visible in the supplied Unit 9 instructions; three minutes is a practical target, not a rubric rule.

## After recording

- Upload the video somewhere the professor can view it; test the link signed out.
- Put its URL in README's **Milestone 2 — current Notes app** entry above the two older videos. Keep both older videos.
- Check the recording box in README and SUBMISSION_CHECKLIST.md; commit/push the link.
- Submit `https://github.com/lalithu/lorca-ios` and the video URL through Canvas per Andros's email. Check whether CodePath also needs the Unit 9 entry and accurate hours. Save the receipt.

## Short navigation addendum after the full recording

Record approximately 20–30 seconds: show Notes, tap the bottom Settings tab, show the connection fields, then tap Notes and show the same note. Say: “I added a Storyboard UITabBarController with Notes and Settings tabs. Each tab retains its navigation state, and switching back preserves my note.” Add the supplemental URL above the full demo in README. The eight-minute usage video remains valid evidence for the existing features; the class presentation separately has a four-minute maximum.

For the same addendum, mention: “The connection profile uses Codable and UserDefaults. Test & Connect uses URLSession with an escaping completion closure. Ollama supplies the local model API; Exa supplies public web search.” These implementations are mapped in README's technical rubric table.
