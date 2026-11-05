# Sprint Plan and Feasibility Notes

## Scope and Schedule
The course defines Units 8–10 as the capstone period. Tonight's verified deadline is **November 4, 2026, 11:59 p.m. EST**. Later unit deadlines must be checked in the live portal; this plan does not invent dates or assume four more weeks remain.

| Sprint | SMART goal / exit evidence | Scope |
|---|---|---|
| Unit 8 — Planning, due tonight | Complete six ideas, three evaluations, selected spec, four required stories, at least one optional story, screen/navigation documentation, wireframe images, and repo submission. Verify all links and image rendering before submitting. | Documents and designs only; no app code. |
| Unit 9 — Connection and first vertical slice, by that unit's deadline | Validate a real authenticated request from an iPhone to the Mac. Build the three UIKit/Storyboard scenes and demonstrate one prompt/reply using the real model. Save/reopen at least one chat after relaunch. Document failures and submit a real progress video. | R1, R2, initial R3. |
| Unit 10 — Complete and demonstrate MVP, by final capstone deadline | Pass all R1–R4 acceptance criteria, including offline history, rename/delete, error handling, and relaunch persistence. Record the final real-device/simulator demo required by the live unit instructions, update README, and prepare live presentation. | Finish R3/R4, reliability and accessible layout. |
| Stretch — Only after MVP acceptance | Choose one optional feature after estimating remaining time. For iMessage, prove one allowlisted incoming message produces exactly one local-model reply, with no historical replay or echo loop. | O1 first if feasible; no promise all stretch work will ship. |

## First Development Decision: Phone-to-Mac Transport
Existing `src/transport.rs` binds an authenticated service to `127.0.0.1:0`, writes its endpoint and token locally, and supports NDJSON events. That is not a phone-ready network API. The macOS runtime has session expiration and one active conversation run, which must inform mobile behavior.

**Candidate approach:** a narrow, opt-in Mac adapter on the trusted local network that authenticates the paired phone and talks to existing Lorca over loopback. This is a proposal, not a selected implementation or an existing feature.

Before implementing the UI's real networking, decide:
1. Reachable address/port and whether manual setup is sufficient.
2. Pairing mechanism, revocation, secure transport, and Keychain storage on the phone.
3. Minimal chat/session API and compatibility/version checks.
4. Request IDs, uncertain acknowledgements, and reconnect without duplicate execution.
5. How phone-owned conversations/context relate to the Mac session without promising full desktop library sync.
6. How to handle existing desktop activity when Lorca is busy.

**Exit gate:** one authenticated physical-iPhone request and real response on the chosen network; wrong credentials must fail. Do not use Simulator-only localhost success as proof a phone can connect. Do not solve reachability by publicly exposing Ollama or the existing broad command API.

## Risk Register

| Risk | Effect | Planned response |
|---|---|---|
| Existing backend is loopback-only | Native app cannot connect as-is | Early transport spike; keep one Mac/manual address; omit discovery initially. |
| Mac asleep/offline or model loading slowly | Request fails or appears stuck | Explicit unavailable/loading state; preserve drafts; bounded timeout and user-controlled retry. |
| Uncertain response after disconnect | Duplicate model requests or incorrect history | Stable request IDs and status reconciliation; no blind replay. |
| Mobile background suspension | Streaming or response interrupted | MVP does not guarantee background completion; persist known state and reconcile on return. |
| Backend supports one active run and owner sessions | Desktop/mobile contention | Define busy response and ownership in connection spike; no mobile approval of desktop tasks in MVP. |
| Two chat stores diverge | User expects sync we have not built | Phone-local history is explicit; no cross-device sync promise. |
| macOS iMessage database/API changes | Stretch bridge breaks | Separate adapter; validate on actual macOS version; keep out of MVP acceptance. |
| iMessage self-replies or repeated delivery | Reply loop or duplicate sends | Allowlist sender/chat, ignore own output, persistent processed-message IDs, rate limit, start/stop control. |
| Course expects hand sketches or interprets video broadly | Submission mismatch | Add photographed hand sketches if possible; rubric video is bonus but page wording conflicts; disclose no build and confirm interpretation if needed. |

## iMessage Stretch Architecture
Phone Messages → Apple's iMessage service → Messages on the Mac → local bridge → Lorca core → Ollama → local bridge → Mac Messages → phone.

The bridge can call Lorca on loopback and does not require exposing Ollama. A distinct Lorca Apple Account/identity is the candidate contact model; it may require a separate macOS user and explicit setup decisions. Mac-side message reading typically requires Full Disk Access and sending requires Messages Automation permission. No permissions or accounts have been changed.

First stretch scope: one trusted sender, text only, one conversation, concise completed replies, no workspace tools or autonomous actions. Message transport uses Apple's service even though inference is local. iMessage is not an on-device iPhone model or a general iOS inbox-listening API.

## Planned Verification (For Implementation Sprints)
- Real Mac/model request; invalid credential; unreachable host; denied local-network permission; busy backend.
- Empty prompt, duplicate send tap, slow reply, interrupted connection, explicit retry.
- Two independent chats; relaunch history; offline reading; rename persistence; cancel/confirm deletion.
- Small iPhone and larger iPhone layouts, keyboard visible, multiline input, Dynamic Type, VoiceOver labels.
- No real credentials or private chat data in the repository or demo.

These are planned acceptance checks, not tests already run. Unit 8 verification concerns documents, completeness, links, and wireframe readability only.

## GitHub and Reporting
Use a dedicated `lorca-ios` repo if available. Keep the existing desktop project linked as prior work. Work on focused branches during implementation; branching is a recommended practice, not a tonight requirement. After each sprint append results, challenges, next steps, and a real demo video to README. Check only implemented/verified app features and preserve earlier milestones.
