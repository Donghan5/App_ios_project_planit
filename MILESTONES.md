# PlanIT - Sprint Milestones

## Current State
- Basic CRUD (create, list, detail, delete) with Core Data
- Three views: ContentView (list), AddScheduleView (form), DetailView (detail)
- Korean UI, SwiftUI framework

---

## Milestone 1: Core UX Polish
**Goal:** Make the existing features feel complete and reliable.

- [ ] Add edit functionality for existing schedule items
- [ ] Add input validation (prevent empty titles, past-date warnings)
- [ ] Improve list UI with section headers grouped by date
- [ ] Add empty state view when no items exist
- [ ] Support dark mode

---

## Milestone 2: Smart Defaults & Quick Actions
**Goal:** Reduce friction when creating and managing items.

- [ ] Smart default time (next round hour) when adding a new item
- [ ] Smart default duration (1 hour)
- [ ] Swipe actions: mark done, quick delete
- [ ] One-tap done with undo (no confirmation dialog)
- [ ] Add "completed" status to MyItem data model

---

## Milestone 3: Architecture & Testing
**Goal:** Establish a maintainable codebase and test coverage.

- [ ] Refactor to MVVM pattern (extract ViewModels)
- [ ] Write unit tests for ViewModel logic
- [ ] Write UI tests for core flows (add, delete, complete)
- [ ] Add error handling for Core Data operations

---

## Milestone 4: Enhanced Features
**Goal:** Deliver the differentiating features from the project vision.

- [ ] Natural language input for events (e.g. "dentist tomorrow 3pm")
- [ ] "Later" pile for low-priority to-dos
- [ ] Swipe gesture to reschedule items
- [ ] Local notifications for upcoming events
- [ ] Calendar view (weekly/monthly) alongside the list view
