# EventSphere 🌐📅

**EventSphere** is a modern, responsive cross-platform event discovery and RSVP platform built with **Flutter**, **Cloud Firestore**, and **Firebase Authentication**.

It features an adaptive UI/UX designed specifically to provide a first-class experience across **Desktop (Windows/macOS/Linux)**, **Web**, **Tablets**, and **Mobile (Android/iOS)**.

---

## ✨ Key Features

- 🖥️ **Adaptive Responsive Architecture**:
  - **Desktop & Web**: Modern collapsible sidebar navigation (`AppSidebar`), responsive multi-column event cards grid (2 to 3 columns), split-screen hero authentication, and centered registration modal dialogs.
  - **Tablet**: Auto-compacting sidebar, 2-column event grid, and touch-optimized action targets.
  - **Mobile**: Intuitive Material 3 bottom navigation bar, full-width fluid event list, and smooth modal bottom sheet for RSVPs.
- 🎨 **Collapsible Sidebar**:
  - Compact (80px) and expanded (260px) state transitions with smooth cubic curves.
  - Active destination highlights with indigo accent indicators.
  - Live user identity badge displaying attendee name, email, and live registered events counter.
  - Quick theme selector (System, Light, Dark) right in the sidebar.
  - Quick sign out confirmation flow.
- 🔍 **Real-time Event Discovery & Search**:
  - Live Cloud Firestore stream of upcoming community events.
  - Live search & filter by title, venue, or description.
  - Interactive hover cards with elevation lift, custom date stamps, and attendee status badges.
- ⚡ **Seamless Authentication**:
  - Google Sign-In with automatic fallback handling across Web popups and native platforms.
  - Zero external image assets required — all icons and branding are drawn natively with Flutter widgets.
- 🌓 **Dynamic Theme Engine**:
  - Real-time switching between Light, Dark, and System modes.
  - Persistent user preference synced to Cloud Firestore.

---

## 📱 Responsive Layout Breakdown

| Device / Form Factor | Breakpoint | Navigation System | Content Layout | RSVP Interaction |
| :--- | :--- | :--- | :--- | :--- |
| **Mobile** | `< 768px` | Bottom `NavigationBar` | 1-Column List | Modal Bottom Sheet |
| **Tablet** | `768px - 1100px` | Compact `AppSidebar` (80px) | 2-Column Grid | Centered Modal Dialog |
| **Desktop & Web** | `≥ 1100px` | Expanded `AppSidebar` (260px, Collapsible) | 2 to 3-Column Grid | Centered Modal Dialog |

---

## 🚀 Building for Release

### 1. Web Release Build
```bash
flutter build web --release
```
Artifacts are generated in `build/web/`.

### 2. Windows Desktop Release Build
```bash
flutter build windows --release
```
Artifacts are generated in `build/windows/x64/runner/Release/`.

### 3. Android APK Release Build
```bash
flutter build apk --release
```
Artifacts are generated in `build/app/outputs/flutter-apk/app-release.apk`.

---

## 🛠️ Tech Stack
- **Framework**: Flutter (Channel stable, Material 3)
- **Backend / Database**: Cloud Firestore
- **Authentication**: Firebase Auth (Google OAuth)
- **State & Theming**: ChangeNotifiers & Reactive StreamBuilders
- **Date Handling**: `intl` package
