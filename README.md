# E-Learning Mobile Application

A lightweight, offline-first Flutter E-Learning application using **MVVM**, **Riverpod**, **Hive NoSQL**, and **Dio**.

---

## Tech Stack
- **Framework**: Flutter (Material 3) SDK 3.44.0
- **Java**: OpenJDK 21.0.0
- **State & DI**: Flutter Riverpod 2.x (No Code Gen)
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Local Storage**: Hive (NoSQL) & Flutter Secure Storage
- **Connectivity**: Connectivity Plus

---

## Architecture Flow

```text
View (UI) ──> ViewModel (Riverpod) ──> Repository ──> Remote (Dio) / Local (Hive)
```

- **MVVM**: Views only display UI; ViewModels manage state and logic.
- **Offline-First**: Course data is cached in Hive NoSQL storage and loaded seamlessly when offline.
- **Zero Code Generation**: Uses plain Dart serialization (`fromJson`/`toJson`) without `build_runner`.

---

## Features
1. **Authentication**: Secure token storage with `FlutterSecureStorage`.
2. **Course Dashboard**: Lists enrolled courses with progress bars and lesson counts.
3. **Course Details & Progress Tracking**: Toggle lesson completion with automatic progress recalculation.
4. **Real-time Connectivity Handling**: Event-driven offline mode indicator and auto-sync when online.
5. **Theme Switcher**: Dark / Light mode toggle in the navigation drawer.

---

## Folder Structure

```text
lib/
├── core/             # Network, Hive DB, Secure Storage, Theme, Router, Widgets
└── features/
    ├── auth/         # Login Page, Auth Repository, User Model
    └── courses/      # Courses & Details Pages, Course Repository, Hive Local Source
```

---

## Quick Start Commands

```bash
flutter pub get      # Install dependencies
flutter analyze      # Run Linter
flutter test         # Run Unit & Widget Tests
flutter run          # Launch Application
```
