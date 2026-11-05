# Capstone Brainstorming — Lorca for iOS

November 4, 2026 • Unit 8 Milestone 1 • Individual project

## 1. Initial Ideas — Six Concepts

| # | Idea | Brief description |
|---|---|---|
| 1 | **Lorca for iOS** | A UIKit/Storyboard phone companion for chatting with a local model hosted by Lorca on the user's Mac, with saved phone-local conversations. An iMessage bridge is a stretch feature. |
| 2 | **Lorca Capture** | Capture quick notes, text, and photos on the phone; organize them into a local inbox and explicitly send selected items to Lorca when connected. |
| 3 | **Lorca Job Companion** | A mobile job-application tracker showing opportunities, notes, stages, and follow-up tasks inspired by Lorca's desktop Job Apps workflow. |
| 4 | **Campus Study Sprint** | A study-session planner that combines a course task list, focus timer, and optional reminders, with locally saved progress. |
| 5 | **Pantry Snapshot** | Photograph or manually enter pantry items, track what should be used soon, and maintain a shopping list. Automatic recognition would be optional. |
| 6 | **Trail Notes** | Save personal walk locations, photos, and short notes in a map-based journal, with offline access to saved entries. |

The lab's opening checklist asks for at least six ideas and evaluation of three; later steps mention three ideas and evaluation of two. This document follows the larger counts to cover both.

## 2. Top Three — Evaluation

These are qualitative planning judgments, not measured market research or completed user testing.

### Idea 1: Lorca for iOS
- **Mobile:** Provides a quick touch-based way to talk to the user's Mac-hosted assistant away from the desk. Offline history is useful without a live Mac connection. Photo input and ordinary iMessage access are potential mobile-native extensions, not MVP commitments.
- **Story:** The user already built Lorca and wants to use the same local AI from their phone. It solves a direct personal problem and gives the demo a clear story: phone prompt → Mac model → phone reply.
- **Market:** A narrow starting audience of Mac/iPhone users already running Lorca or Ollama, especially people who prefer personally hosted inference. No broad adoption claim is made.
- **Habit:** Repeated questions, follow-up conversations, and reopening explanations can create daily use. Users create content as well as consume replies.
- **Scope:** Three core screens and four required stories can form a demonstrable app. The major risk is secure phone-to-Mac access because current Lorca is loopback-only. A constrained first release can use one manually configured Mac, text-only completed responses, and phone-local history. iMessage, vision, and streaming are optional.
- **Assessment:** Strong personal motivation and a concrete end-to-end demonstration; connection feasibility must be checked early.

### Idea 2: Lorca Capture
- **Mobile:** Fast capture from the phone, optional camera/photo input, and offline use fit mobile well. A Share extension could later accept text/URLs from other apps.
- **Story:** Useful ideas often arrive away from the Mac. Capture them immediately, then deliberately bring them into the assistant's workspace later.
- **Market:** Existing Lorca users, students, and people who collect research snippets. The Lorca-specific audience is small; broader appeal would need validation.
- **Habit:** Frequent small captures and periodic review; value depends on reliably returning to the inbox rather than letting notes accumulate.
- **Scope:** Local capture, edit, delete, and organization are achievable without a backend. Sending to Lorca still introduces transport and conflict questions. OCR, automatic categorization, and cross-device sync would increase scope substantially.
- **Assessment:** Lowest-risk offline MVP and good mobile fit, but less directly aligned with the user's primary goal of chatting with the local model.

### Idea 3: Lorca Job Companion
- **Mobile:** Review opportunities and follow-up tasks away from the desk; optional local reminders and document/photo capture. Existing desktop integration does not automatically make mobile sync available.
- **Story:** A student can track applications and remember follow-ups in one place rather than scattered notes.
- **Market:** Students and early-career applicants; a relatable audience, though many alternatives exist. Differentiation would depend on a useful Lorca integration.
- **Habit:** Regular use during active application periods; less frequent once the search ends.
- **Scope:** A local tracker is feasible, but syncing desktop records, resolving conflicts, personal-data handling, Google authorization, and drafting workflows would expand the project. Read-only mobile access would be a narrower version.
- **Assessment:** Useful but introduces more data and integration complexity than necessary for the main chat goal.

## 3. Decision

**Chosen: Lorca for iOS.**

The selected project directly serves the student's intended use: talking to their local model from an iPhone. Its core user journey is easy to explain and demonstrate, and its screens map naturally to UIKit concepts covered in the course. Existing Lorca supplies the Mac-side AI foundation, while the iOS client remains new capstone work.

The chosen implementation is a **UIKit app built with Storyboard**. The MVP includes connection setup/status, real text chat, persistent phone-local history, and rename/delete management. A Mac-side iMessage bridge that lets the user text Lorca like a person is a **stretch feature**, not an iMessage app-drawer extension and not a required dependency for completing the capstone.

We choose this over Capture because direct conversation is the central need. We choose it over Job Companion to avoid Google integration and job-record synchronization in the MVP. Connection validation is the first development checkpoint; if it proves larger than expected, reduce optional features and revisit the connection plan explicitly rather than presenting mock responses as completed functionality.

## 4. Initial Constraints
- One user, one Mac, same trusted local network for the native app MVP.
- Mac awake, Lorca and Ollama available, installed model capable of text chat.
- No mobile on-device model, cloud inference, public Ollama exposure, or automatic desktop history sync promised.
- At the initial brainstorming stage, no iOS implementation existed. A basic Storyboard prototype has since been added under `ios/`; see README for current progress. Prior desktop work is attributed separately.
- Course eligibility for an original iOS companion built around existing personal backend work is not explicitly addressed in the published instructions; disclose the boundary and confirm with the instructor if needed.
