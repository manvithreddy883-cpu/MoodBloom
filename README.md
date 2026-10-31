# MoodBloom – Friend App

Lavender Milk Flutter starter. This milestone implements the Friend App interface and local demo interactions. It does **not** yet connect to Firebase or persist data after the app closes.

## Included
- Home, Mood Space, Mood History/Calendar, Daily Photo Check-in
- Virtual Garden, Virtual Companion, Games/Quests
- Diary/Memories, Calm Corner, Messages, Settings
- Lavender Milk theme, cards, gradients, rounded controls and breathing animation
- Five-tab navigation with all remaining screens under More

## Run in a cloud development workspace (Android phone only)
1. Create a private GitHub repository named `moodbloom-friend-app`.
2. Upload the contents of this ZIP. Upload the files inside the folder, not the ZIP itself.
3. In GitHub, open the repository. Select **Code → Codespaces → Create codespace on main**.
4. In the Codespaces terminal, run:
   ```bash
   flutter doctor
   flutter create --platforms=android,web .
   flutter pub get
   flutter run -d web-server --web-hostname 0.0.0.0
   ```
   Open the forwarded port shown by Codespaces to preview the Flutter UI. This is a Flutter web preview for development only; the deliverable remains a native Android APK.
5. For an Android APK, run:
   ```bash
   flutter build apk --release
   ```
   Download `build/app/outputs/flutter-apk/app-release.apk` from the Codespaces file explorer.

## Firebase next phase
The earlier Firebase project and Email/Password provider are retained as completed setup. Before integration, register an Android app in Firebase with the final Android application ID, download `google-services.json`, and add FlutterFire packages/configuration. Then implement Auth, Firestore repositories, Storage uploads, and FCM.

## Important demo limits
- Mood entries, diary notes, garden flowers and pet interactions are held in app memory only.
- The photo screen is a UI placeholder. Image picker and Firebase Storage upload are not wired yet.
- Authentication, cross-device sync, notifications and admin functionality are intentionally not included in this Friend App UI milestone.
- Diary and memories must remain private to the friend account. Only explicitly shared items should be visible to another account.
