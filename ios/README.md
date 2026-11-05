# Lorca iOS — Early Storyboard Prototype

Open `LorcaIOS.xcodeproj` in Xcode, choose the LorcaIOS scheme and an iPhone Simulator, and Run. Requires Xcode with an installed iOS Simulator runtime. No packages or signing account are needed for a Simulator build.

## Implemented in this prototype
- UIKit/Storyboard scenes: Conversations, Chat, Connection Settings.
- Navigation controller pushes Chat; Settings opens modally and returns to its caller.
- New conversations persist locally in UserDefaults.
- Swipe a conversation row for Rename or Delete; deletion asks for confirmation.
- Message drafts persist immediately and restore when reopening the conversation.
- A Mac address can be saved, restored, and cleared locally.
- Unimplemented pairing and sending are visibly disabled/labeled.

## Not implemented
No network connection, credential pairing, model responses, streaming, completed-message history, desktop sync, iMessage bridge, or remote tools. A saved address is not a successful connection. A draft is not a sent message. The app makes no simulated AI replies.

## Command-line build
```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcodebuild -project LorcaIOS.xcodeproj -scheme LorcaIOS \
  -sdk iphonesimulator -configuration Debug \
  -derivedDataPath /tmp/lorca-ios-build CODE_SIGNING_ALLOWED=NO build
```

## Short real-build demo
1. Start on Conversations; show the prototype label.
2. Open Settings, type `my-mac.local`, Save Address, and Done. Explain this saves settings only.
3. New → write a message draft → Done (keyboard) → Back.
4. Reopen the conversation to demonstrate restored draft.
5. Back → swipe row → Rename → Save.
6. Optionally demonstrate Delete → Cancel, so viewers see the confirmation.
7. Finish with: “This is the first working Storyboard build. Next is the real Mac/Ollama connection.”

Do not represent the current disabled Send control as live AI chat. The planning walkthrough is separate from this build demo.
