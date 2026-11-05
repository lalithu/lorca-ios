# Low Fidelity Wireframe Annotations

The numbered PNGs are digital planning drawings; hand-sketch-main.jpg is the student’s actual paper sketch. None is an app build or interactive prototype. Sample messages are fictional.

## 01 — Core Screens
- **Conversations:** New opens an empty Chat. Settings opens Connection Settings. A row opens its saved Chat. Row actions expose Rename/Delete with a confirmation before deletion.
- **Chat:** Back preserves history/draft. Connection banner opens Settings if unavailable. Transcript shows sender labels in addition to alignment. Send is disabled for empty input, while disconnected, or during a request. MVP shows a waiting state and then a complete reply; token streaming and Stop are stretch work.
- **Connection Settings:** Host is manually entered initially. Pairing credential is obscured. Test & Save must validate the endpoint and authorization before showing Connected. Done returns to the originating screen. Disconnect disables live requests without deleting saved history.

## 02 — Screen States
- **Empty library:** explain the app; connect and create chat actions. No fabricated conversation history.
- **Waiting:** show the submitted prompt and progress text; prevent duplicate send; do not imply a working stream. Draft remains recoverable.
- **Offline:** saved transcript remains visible; banner explains the Mac is unavailable; reconnect opens Settings. Sending is disabled until connection is restored.
- **Failed request:** distinguish an error from an assistant answer; preserve prompt; explicit Retry only after request status is known. Do not automatically resend on navigation/relaunch.

## 03 — Navigation
A navigation controller owns Conversations → Chat. Connection Settings is modal, returns to its caller, and preserves the draft. Rename is a modal and Delete is a confirmation alert, not full-screen tabs. There is no tab bar.

## Accessibility and Layout Intent
Use Auto Layout with safe areas and a keyboard-aware composer. Support Dynamic Type, descriptive VoiceOver labels, sufficient contrast, and comfortable touch targets. Status/error meaning must use text, not color alone. Long messages wrap and scroll. These are implementation requirements to verify later, not claims of tested behavior.

## 04 — Dialogs and Connection Failure
- **Rename:** editable title, Save and Cancel; empty titles cannot be saved.
- **Delete:** names the conversation, explains phone-local scope, and offers Cancel/Delete.
- **Connection failure:** keeps address and masked credential visible for correction; Test & Save retries; Done dismisses without claiming a connection. While testing, show Connecting.
- Distinguish unreachable Mac, invalid credential, denied local-network permission, incompatible service, and busy Mac with specific guidance.

## Paper Sketch — Included
`hand-sketch-main.jpg` is the student's photographed paper wireframe for Conversations, Chat, Connection Settings, and navigation arrows. The numbered digital sheets supplement it with detailed controls, dialogs, and states. The original photograph is preserved without redrawing or generated modifications.
