# Tasks: iOS Nearby Stops and Arrivals

**Input**: Design documents from `/specs/001-bus-line-search/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: No explicit test tasks requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare the existing iOS scaffold for the transit feature set

- [ ] T001 [P] Create the transit feature folders `Services/`, `Features/Map/`, `Features/StopDetails/`, `Features/Permissions/`, and `Models/`
- [ ] T002 Replace the SwiftData sample scaffold with the transit app shell in `OpenBusSPApp.swift`, `ContentView.swift`, and `Item.swift`
- [ ] T003 Add the app-level location usage copy and any required permission text in `Info.plist`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core app services and models required before any story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 [P] Define the core transit entities in `Models/TransitStop.swift`, `Models/TransitLine.swift`, and `Models/StopArrival.swift`
- [ ] T005 [P] Define the transient location query state in `Models/NearbyStopQuery.swift`
- [x] T006 Implement the SPTrans client for line lookup, stop lookup, and arrival lookup in `Services/TransitAPIClient.swift`
- [ ] T007 [P] Implement location authorization and current-position tracking in `Services/LocationService.swift`
- [ ] T008 Implement nearby-stop resolution and proximity filtering in `Services/NearbyStopStore.swift`
- [x] T009 Wire shared application state into the root view hierarchy in `OpenBusSPApp.swift` and `ContentView.swift`

**Checkpoint**: The app can load its core state, request location, and talk to the transit service layer

---

## Phase 3: User Story 1 - Show Nearby Stops on the Map (Priority: P1) 🎯 MVP

**Goal**: Show the user's position on a map and render nearby SPTrans stops as selectable annotations

**Independent Test**: Launch the app, grant location access, and confirm that the map centers on the user with nearby stops visible and selectable

### Implementation for User Story 1

- [ ] T010 [P] [US1] Build the primary map screen container and loading state in `Features/Map/NearbyStopsMapView.swift`
- [ ] T011 [P] [US1] Render the user location and nearby stop annotations in `Features/Map/NearbyStopsMapView.swift`
- [ ] T012 [US1] Connect the map screen to `Services/LocationService.swift` and `Services/NearbyStopStore.swift` so the visible stops refresh with the current position
- [ ] T013 [US1] Add the empty-state message for areas with no nearby stops in `Features/Map/NearbyStopsMapView.swift`

**Checkpoint**: The map experience is usable on its own and already delivers core value

---

## Phase 4: User Story 2 - Show Stop Details and Arrivals (Priority: P2)

**Goal**: Open a selected stop and show the lines that serve it, along with the predicted arrivals available for that stop

**Independent Test**: Select a stop annotation and confirm that the detail view shows the stop identity, associated lines, and arrival order without needing another story to be complete

### Implementation for User Story 2

- [ ] T014 [P] [US2] Create the stop selection detail state model in `Features/StopDetails/StopDetailViewModel.swift`
- [ ] T015 [P] [US2] Build the stop detail sheet or panel in `Features/StopDetails/StopDetailView.swift`
- [ ] T016 [US2] Fetch the selected stop's lines and arrivals in `Features/StopDetails/StopDetailViewModel.swift` using `Services/TransitAPIClient.swift`
- [ ] T017 [US2] Show stop identity, line list, and predicted arrival order in `Features/StopDetails/StopDetailView.swift`

**Checkpoint**: Selecting a stop exposes the transit details the user needs to confirm the point

---

## Phase 5: User Story 3 - Handle Permissions and Recovery States (Priority: P3)

**Goal**: Explain why the map cannot load nearby stops and let the user recover from permission, connectivity, or data issues

**Independent Test**: Deny location access or interrupt data loading, then confirm that the app shows a clear explanation and a retry path

### Implementation for User Story 3

- [ ] T018 [P] [US3] Add the location-permission and denial-state UI in `Features/Permissions/LocationPermissionView.swift`
- [ ] T019 [US3] Add retry actions and recoverable error messaging in `Features/Map/NearbyStopsMapView.swift` and `Features/StopDetails/StopDetailViewModel.swift`
- [ ] T020 [US3] Handle network and SPTrans unavailability in `Services/TransitAPIClient.swift` with user-facing error states
- [ ] T021 [US3] Add the no-results fallback for stop loading and line lookups in `Features/Map/NearbyStopsMapView.swift` and `Features/StopDetails/StopDetailView.swift`

**Checkpoint**: The app communicates failures clearly and gives the user a next step

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Finish the feature, clean up the scaffold, and validate the user-facing flow

- [ ] T022 Update `specs/001-bus-line-search/quickstart.md` to match the implemented map and stop-detail flow
- [ ] T023 Remove leftover sample-app dependencies from `Item.swift`, `OpenBusSPApp.swift`, and `ContentView.swift`
- [ ] T024 Validate the end-to-end flow against `specs/001-bus-line-search/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - blocks all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in priority order or in parallel once their shared dependencies are ready
- **Polish (Final Phase)**: Depends on the desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - no dependency on other user stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - integrates with the map selection flow but stays independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - wraps failure and recovery behavior around the same core flow

### Within Each User Story

- Core shared models and services before UI wiring
- UI states before polish and recovery details
- Story complete before moving to the next priority

### Parallel Opportunities

- Setup tasks T001 and T003 can run alongside T002 if the team can touch different files
- Foundational tasks T004, T005, T007, and T008 can proceed in parallel once the folder structure exists
- User Story 1 tasks T010 and T011 can proceed in parallel after the shared services are ready
- User Story 2 tasks T014 and T015 can proceed in parallel after the shared stop model exists
- User Story 3 tasks T018 can proceed independently of the map and detail UI polish

---

## Implementation Strategy

### MVP First

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and validate the map flow on its own

### Incremental Delivery

1. Ship the map with nearby stops first
2. Add stop details and arrivals second
3. Add permission, error, and retry handling last
4. Finish with quickstart validation and scaffold cleanup

### Parallel Team Strategy

1. One developer can wire the services and models while another builds the map screen
2. Once the map is ready, a second developer can add stop details in parallel with recovery states
3. The final pass can focus on polish and quickstart validation

---

## Notes

- [P] tasks mean different files and no dependency on incomplete work
- [Story] labels map each task to a specific user story for traceability
- The MVP scope is User Story 1
- Keep task descriptions file-specific so each step is immediately actionable
