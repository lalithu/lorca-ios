# Lorca iOS — run the Notes build

Open `LorcaIOS.xcodeproj`, select **LorcaIOS**, select an installed iPhone Simulator, and Run. The app uses UIKit, a real Main.storyboard, Auto Layout, UINavigationController, UITableView, UITextView and native alerts. Light mode is enforced. No SwiftUI or third-party dependencies.

## Instructor setup: local model required only for AI

Notes work and persist without any server. To see real model assistance:

1. Install [Ollama](https://ollama.com/download) on your Mac and launch it.
2. Download a model once. `ollama pull qwen3:4b` is a smaller option (about 2.5 GB); `ollama pull qwen3:14b` matches the model used for this build's live check and needs more memory/storage. Choose a model your Mac can run. No models are bundled or automatically downloaded by the app.
3. In the iPhone Simulator app, open **Settings**. Address: `http://127.0.0.1:11434`. Model: the exact installed model name, such as `qwen3:4b`.
4. Tap **Test & Connect**. Only an actual successful server/model check displays Connected.
5. Done → + → write `Study guide for counting and permutations:` followed by topics, then start another paragraph. The local model works while you continue writing.

The system's Simulator can reach the Mac's localhost. On a **physical iPhone**, localhost means the phone itself: use your Mac's Wi-Fi IP instead. Keep both devices on the same trusted network and allow Local Network permission. Ollama normally listens only on localhost; to allow your own phone, follow [Ollama's documented OLLAMA_HOST setup](https://docs.ollama.com/faq#how-do-i-configure-ollama-server). For the Ollama Mac app:

```sh
launchctl setenv OLLAMA_HOST "0.0.0.0:11434"
```

Then quit/reopen Ollama and use `http://YOUR_MAC_WIFI_IP:11434` on the phone. This opens Ollama to devices that can reach that network interface: use only a trusted LAN, do not port-forward it, and restore localhost afterward with `launchctl unsetenv OLLAMA_HOST` and restart Ollama. This prototype does not implement the authenticated pairing originally proposed in Milestone 1.

References: [Ollama network configuration](https://docs.ollama.com/faq), [chat API](https://docs.ollama.com/api/chat), [Qwen3 4B model](https://ollama.com/library/qwen3:4b).

## Short demo flow

- Create a note, type a study-guide heading and topics, and show real inline output.
- Keep original text and edit generated text in place. Show pause/retry from Model following.
- Create Things to Do with several tasks; tap a checkbox and show completed items move down.
- Return to Notes, search, rename, and show Delete → Cancel.
- Relaunch and reopen a saved note.
- Optionally import a screenshot through Photos; the text is recognized locally and can be summarized by the selected model.

Text is sent to the configured Mac; inference is not on the iPhone. AI requires an awake reachable Mac. Web research additionally needs internet and sends a query to Exa. Notes are phone-local; there is no desktop synchronization. Tables are lightweight inline text columns, not the macOS NSTextTable implementation. Photo import summarizes recognized text rather than claiming full visual captioning. Calendar export is not in this iOS build.

## Build command

```sh
xcodebuild -project LorcaIOS.xcodeproj -scheme LorcaIOS \
  -sdk iphonesimulator -configuration Debug \
  -derivedDataPath /tmp/lorca-ios-build CODE_SIGNING_ALLOWED=NO build
```

A physical device additionally requires your own Apple signing team. Existing Unit 8 videos remain historical; a new Milestone 2 video is still required before submission.
