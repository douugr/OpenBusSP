# OpenBusSP

OpenBusSP is an iOS app for finding nearby bus stops and checking bus lines in São Paulo using SPTrans Olho Vivo data and Apple Maps-based location flows.

## Status

The project is currently in the planning stage. The repository already contains the feature specification, implementation plan, task breakdown, and supporting design docs for the first feature slice.

## Planned Experience

- Show the user's current location on a map
- Display nearby SPTrans bus stops as selectable points
- Open a stop detail view with the lines that serve that stop
- Show arrival predictions for the selected stop when available
- Explain permission, no-results, and connectivity failures clearly

## Tech Direction

- iOS-only app
- SwiftUI user interface
- MapKit for map presentation
- CoreLocation for user positioning and permission flow
- SPTrans Olho Vivo as the live transit data source

## Project Docs

- [Feature spec](specs/001-bus-line-search/spec.md)
- [Implementation plan](specs/001-bus-line-search/plan.md)
- [Research notes](specs/001-bus-line-search/research.md)
- [Data model](specs/001-bus-line-search/data-model.md)
- [UI contract](specs/001-bus-line-search/contracts/stop-map-flow.md)
- [Implementation tasks](specs/001-bus-line-search/tasks.md)

## Current Repository Layout

- `OpenBusSPApp.swift`
- `ContentView.swift`
- `Item.swift`
- `Assets.xcassets/`
- `specs/001-bus-line-search/`
- `.specify/`

## Getting Started

1. Open the project in Xcode.
2. Select an iOS simulator or physical device.
3. Build and run the app from Xcode.

## Roadmap

- Implement the nearby stops map flow
- Add stop detail and arrival information
- Finish error handling and permission recovery
- Add automated validation around the core user journeys
