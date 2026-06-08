# Implementation Plan: iOS Nearby Stops and Arrivals

**Branch**: `001-bus-line-search` | **Date**: 2026-06-08 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-bus-line-search/spec.md`

**Note**: This plan is filled in by the `/speckit-plan` command.

## Summary

Build an iOS-only transit experience that centers the map on the user's current location, shows nearby SPTrans bus stops as map annotations, and opens a stop detail view that lists the lines and upcoming arrivals for the selected stop. The implementation uses Apple's location and map frameworks for discovery and presentation, and the SPTrans Olho Vivo service for live stop and line data.

## Technical Context

**Language/Version**: Swift 5.x, iOS app using SwiftUI

**Primary Dependencies**: SwiftUI, MapKit, CoreLocation, SwiftData (existing project scaffold), URLSession-based network layer

**Storage**: N/A for core transit data; transient in-memory state for map selection and permissions, with optional local cache later if needed

**Testing**: XCTest for unit and integration coverage; Xcode simulator runs for location and map flows

**Target Platform**: iOS 17+

**Project Type**: mobile-app

**Performance Goals**: show the user location and the first set of nearby stops within 5 seconds under normal network conditions; open a selected stop's arrival list within 2 seconds after data is available

**Constraints**: location access requires user permission; live arrivals depend on SPTrans availability and network connectivity; the app remains exclusive to iPhone and iPad

**Scale/Scope**: single-app consumer experience with one primary map screen and one stop detail flow; no backend service and no account system

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

No active constitution violations are known for this feature. The scope stays narrow, user-facing, and testable, so no complexity justification is required.

## Project Structure

### Documentation (this feature)

```text
specs/001-bus-line-search/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
OpenBusSPApp.swift
ContentView.swift
Item.swift
Assets.xcassets/
Services/
├── TransitAPIClient.swift
├── LocationService.swift
└── NearbyStopStore.swift

Features/
├── Map/
├── StopDetails/
└── Permissions/

Models/
├── TransitStop.swift
├── TransitLine.swift
└── StopArrival.swift

Tests/
├── OpenBusSPTests/
└── OpenBusSPUITests/
```

**Structure Decision**: Keep the existing SwiftUI app entry point, then group the feature into service, model, and feature folders to isolate map/location logic from transit data loading and stop detail presentation.

## Phase 0: Research

- Confirm the minimum iOS location permission flow needed for an in-app map experience.
- Confirm the MapKit presentation pattern for showing the user location and nearby annotations.
- Confirm the Olho Vivo endpoints needed for line lookup, stop lookup, and stop arrival predictions.
- Define a practical interpretation of "nearby stops" that is compatible with the available SPTrans data.

## Phase 1: Design & Contracts

- Write `research.md` with decisions and alternatives.
- Write `data-model.md` for stops, lines, and arrivals.
- Write `contracts/stop-map-flow.md` for the user-facing screen and state contract.
- Write `quickstart.md` with end-to-end validation scenarios.
- Update the managed agent context so it points at this plan.

## Complexity Tracking

No constitution violations need justification.
