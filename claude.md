# CLAUDE.md — PlanIt (Flutter)

## Project Overview

**PlanIt** is a calendar + to-do app designed for the laziest people possible.
Originally built in Swift (iOS), now being migrated to Flutter for cross-platform support.

The core philosophy: **minimum friction, maximum done**. Features should reduce cognitive load, not add to it.

---

## Tech Stack

- **Framework**: Flutter (Dart)
- **Target Platforms**: iOS (primary), Android
- **State Management**: [e.g., Riverpod / Bloc — specify your choice]
- **Local Storage**: Hive or Isar (for offline-first calendar/todo data)
- **Navigation**: GoRouter
- **Calendar Package**: `table_calendar` or custom implementation

---

## Migration Context: Swift → Flutter

When migrating Swift code:
- `UIViewController` → `StatefulWidget`
- `UITableView / UICollectionView` → `ListView` / `GridView`
- `CoreData` → Hive / Isar / SQLite (via `drift`)
- `UserDefaults` → `shared_preferences`
- `NotificationCenter` → `flutter_local_notifications`
- `EventKit` (iOS Calendar) → `device_calendar` package
- Swift `@State` / `@Binding` / `@ObservedObject` → Riverpod `StateNotifier` / `Provider`
- Combine → Riverpod streams or RxDart
- SwiftUI `View` → Flutter `Widget`

Always check if a native Swift feature has a Flutter package equivalent before writing custom platform channels.

---

## Core Features

### 1. Lazy Calendar
- Default view: **Today** (not the full month — the lazy default)
- One-tap event creation with smart defaults (e.g., duration = 1 hour, time = next round hour)
- Natural language input for events ("dentist tomorrow 3pm")
- Swipe gestures for quick reschedule

### 2. Smart To-Do List
- Tasks auto-linked to calendar dates
- "Later" pile — a guilt-free place to dump tasks without a date
- One-tap to mark done (no confirmation dialogs)

### 3. Minimal UI Principles
- No mandatory fields — everything optional except the title
- Smart defaults everywhere
- Undo instead of "Are you sure?" popups

---

## Project Structure

```
lib/
├── main.dart
├── app/
│   ├── router.dart
│   └── theme.dart
├── features/
│   ├── calendar/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── todo/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── home/
├── shared/
│   ├── widgets/
│   ├── utils/
│   └── constants/
└── core/
    ├── storage/
    └── notifications/
```

Use **feature-first** folder structure. Each feature has its own data/domain/presentation layers.

---

## Code Conventions

- **Language**: Dart, following [Effective Dart](https://dart.dev/guides/language/effective-dart)
- **Naming**: `snake_case` for files, `PascalCase` for classes, `camelCase` for variables
- **Widget files**: one widget per file
- **No `var`** — always type explicitly unless type is 100% obvious from context
- Prefer `const` constructors wherever possible
- Keep `build()` methods lean — extract sub-widgets early

### Flutter-Specific Rules
- Never put business logic inside widgets
- Use `Key` for list items that can reorder/animate
- Always handle loading + error states in UI
- Prefer `AsyncValue` (Riverpod) over manual `isLoading` booleans

---

## UI / UX Guidelines

- **Theme**: Clean, minimal — think iOS Calendar vibes but lazier
- Support **dark mode** from day one
- Touch targets minimum **44x44px**
- Animations: subtle, fast (150–250ms) — never block the user
- Empty states should be friendly and actionable, not just "No items"

---

## Testing

- Unit tests for all domain logic (use cases, models)
- Widget tests for critical UI components (calendar day cell, todo item)
- Integration tests for core flows (create event, complete task)

Run tests: `flutter test`

---

## Common Commands

```bash
# Run app
flutter run

# Build iOS
flutter build ios

# Build Android
flutter build apk

# Generate code (if using build_runner)
dart run build_runner build --delete-conflicting-outputs

# Analyze
flutter analyze

# Format
dart format .
```

---

## Things to Watch Out For

- **Timezone handling**: Always store times in UTC, display in local timezone
- **iOS permissions**: Calendar and notification permissions need explicit user approval — handle gracefully
- **Keyboard overlap**: Use `resizeToAvoidBottomInset` and scroll padding for input forms
- When in doubt between a fancy solution and a simple one — **pick simple**. This is PlanIt, not NASA.
