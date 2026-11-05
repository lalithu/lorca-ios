# Hand Sketch Copy Guide — Lorca for iOS

Use one landscape sheet for A–C and their navigation arrows. Use a second sheet for D–E and the small state notes. Pen or pencil is fine. These are low fidelity sketches; no color, ruler, branding, or realistic phone frame is needed. Label the page “Lorca for iOS — Unit 8 Wireframes” and date it.

## Sheet 1: Three Main Screens

Draw three tall rectangles, spaced far enough apart to draw arrows. Label them A, B, C.

### A. Conversations — left rectangle
```
+----------------------------+
| Conversations              |
| [Settings]       [+ New]   |
|----------------------------|
| Swift study notes       >  |
| Explain recursion...       |
|----------------------------|
| Weekend ideas           >  |
| Saved message preview...   |
|----------------------------|
|                            |
| Selected row:              |
| [Rename]        [Delete]   |
|                            |
| Saved on this iPhone       |
+----------------------------+
```
Write beside the row actions: “Available for each conversation.” These can be represented as buttons for the sketch; actual implementation may use a row menu/swipe action.

### B. Chat — middle rectangle
```
+----------------------------+
| [< Chats]          Chat    |
| [Connected to Mac]         |
|----------------------------|
|                  You       |
|   Explain recursion.       |
|                            |
| Lorca                      |
| A function calls itself    |
| on a smaller problem.      |
|                            |
|----------------------------|
| [Write a message...]       |
|                   [Send]   |
+----------------------------+
```
Write beside it: “Messages scroll. Input expands/wraps. Send disabled when empty, disconnected, or waiting. Tapping unavailable connection status opens C.” The connected example is not an error; the banner becomes a connection action when disconnected.

### C. Connection Settings — right rectangle
```
+----------------------------+
| Connection Settings [Done] |
|----------------------------|
| Mac address                |
| [Mac host / address     ]  |
|                            |
| Pairing credential         |
| [************           ]  |
|                            |
| [Test & Save]              |
| Status: Connected          |
|                            |
| Mac must be awake and on   |
| the same network.          |
|                            |
| [Disconnect]               |
+----------------------------+
```
Write beside it: “While testing: Connecting. Success only after validation. Disconnect keeps saved history. Done returns to the screen that opened Settings.”

## Arrows on Sheet 1

Draw arrows outside the rectangles, using both directions where indicated:
1. A → B, label “Tap chat / + New”. B → A, label “< Chats”. A double-headed arrow with the two labels is fine.
2. A → C, label “Settings”. C → A, label “Done (opened from A)”. Route this line above the rectangles so it does not pass through B.
3. B → C, label “Disconnected banner”. C → B, label “Done (opened from B)”. Route this line below the rectangles if needed.
4. A → D on sheet 2, label “Rename”. Write “D Save/Cancel → A”.
5. A → E on sheet 2, label “Delete”. Write “E Delete/Cancel → A”.
6. Inside B, draw a small arrow from Send to the transcript, label “Prompt → Waiting → Reply / Error”. This is a state change, not another screen.

There is NO tab bar and NO required iMessage screen.

## Sheet 2: Dialogs and States

### D. Rename — a small popup rectangle
```
+----------------------------+
| Rename conversation        |
| Title                      |
| [Swift study notes      ]  |
| [Cancel]          [Save]   |
+----------------------------+
```
Draw arrows back to “A — Conversations”: Save updates the title; Cancel keeps the old title. Annotate “Title cannot be empty.”

### E. Delete Confirmation — a small popup rectangle
```
+----------------------------+
| Delete conversation?       |
| Delete Swift study notes   |
| from this iPhone?          |
| Mac library unchanged.     |
| [Cancel]         [Delete]  |
+----------------------------+
```
Draw arrows back to A: Cancel retains the chat; Delete removes only that local conversation.

### Small state boxes (do not redraw full phones)
These reinforce the spec; label each with its parent screen.

**A — Empty:** “No conversations yet” + [Connect to Mac] + [+ New Chat]. Arrows: Connect → C; New → B.

**B — Waiting:** “Lorca is generating…” and “Send disabled”. Arrow to Reply when complete or Error on failure. No Stop button is required; streaming/stop is stretch work.

**B — Offline:** “Mac unavailable. Saved history is readable.” + [Reconnect]. Arrow Reconnect → C. Annotate “Draft kept; Send disabled”.

**B — Error:** “Could not receive reply. Prompt saved.” + [Retry]. Retry → Waiting only after checking the original request status, to avoid sending twice.

**C — Connection failure:** “Mac could not be reached. Check address and that Lorca is running.” + [Test & Save]. Arrow to Connecting, then Connected or Error. Note other errors: wrong credential, denied local-network permission, incompatible service, busy Mac.

## Photograph Checklist
- Include the full sheets with labels and arrowheads readable.
- Use good lighting; hold the phone parallel to the paper.
- Fictional sample text only; do not write real passwords or pairing credentials.
- Send both photos. We will add them under wireframes/ and embed them in README in a follow-up commit.
