# Lorca iOS — implementation notes

**Start here:** [Simulator quick start in the main README](../README.md#run-in-simulator--instructor-quick-start). The professor runs this app entirely in Simulator on the same Mac as Ollama. No phone, pairing adapter, LAN configuration, or signing team is required.

## Build and runtime

- Open `LorcaIOS.xcodeproj`; scheme **LorcaIOS**; choose an installed iPhone Simulator; ⌘R.
- Xcode 26+ SDK is required to compile guarded native glass button styles. Deployment target: iOS 17. Verified build: Xcode 27.2, iOS 18 Simulator.
- UIKit, Main.storyboard, Auto Layout, UINavigationController, UITableView, UITextView, native alerts and Photos picker. Light mode. No SwiftUI or third-party app dependencies.
- Ollama runs on the Mac at `http://127.0.0.1:11434`. Use `qwen3:4b` for the smaller documented setup; `qwen3:14b` was used in the live acceptance check. Set the exact model in Settings.

## Source map

- `AppDelegate.swift`: scene lifecycle, Storyboard launch, light mode.
- `Base.lproj/Main.storyboard`: Notes list, editor and Connection Settings, outlets/actions and Auto Layout.
- `Controllers.swift`: navigation, native editing controls, connection UI, Photos import and Vision OCR.
- `NotesEngine.swift`: local storage/migration, passage selection, model requests, optional research, inline formatting/checklists, progress and undo behavior.
- `../LorcaIOSUITests/NotesFlowTests.swift`: focused Simulator acceptance checks. The real-model test requires an installed `qwen3:14b`.

## Data and request flow

`Note` stores UUID, title, text, RTF data, generated/edited ranges, processed source snapshots and update time. `NotesStore` writes atomic `Documents/notes.json` inside the Simulator app sandbox. Earlier prototype drafts migrate without deleting the original preferences. Connection address/model and selected-note ID are in UserDefaults. There are no embedded credentials, model weights, user notes or build products in the submitted source archive.

Settled passages are considered independently. Work waits briefly for typing to settle, sends a bounded source/context snapshot to Ollama `/api/chat`, checks the structured response and source, then inserts editable content below the author's writing. Changed/paused work is cancelled or rejected when stale. The inline pulsing cue is a UIKit view, not saved document text; Reduce Motion uses static dots.

`/api/tags` checks reachability and the installed model. The app does not silently download a model. Research requests use Exa over HTTPS and supply search evidence to the local model. No desktop Lorca/Rust backend is required. Screenshot import sends recognized text for summarization; it does not claim image understanding. Inference does not run on iOS.

## Scope and history

The earlier phone-to-Mac chat/pairing design is preserved in [Milestone 1](../docs/milestone-1.md). The final scope is a Simulator-first note editor. Desktop-note sync, authenticated phone pairing, iMessage, visual captioning and ICS export remain unimplemented.

See [requirements and validation limits](../REQUIREMENTS_REVIEW.md) and [video checklist](../VIDEO_DEMO.md).
