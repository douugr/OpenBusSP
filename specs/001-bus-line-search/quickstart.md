# Quickstart

## Purpose

Validate the feature end to end from the user's point of view.

## Prerequisites

- An iPhone simulator or physical iPhone with location services enabled.
- A valid SPTrans Olho Vivo access token configured in the app environment.
- A buildable iOS project target for `OpenBusSP`.

## Validation Scenarios

### 1. Nearby stops appear on the map

1. Launch the app.
2. Allow location access when prompted.
3. Wait for the map to center on the current location.
4. Confirm that nearby bus stop annotations appear around the user location.

**Expected result**: the user sees a map centered on their position and a visible set of nearby stops.

### 2. Selecting a stop shows its lines

1. Tap one of the stop annotations on the map.
2. Open the stop detail view.
3. Review the lines listed for that stop.

**Expected result**: the detail view shows the selected stop and the lines that serve it.

### 3. Arrival data is visible

1. Keep the stop detail view open.
2. Review the arrival list for each line.

**Expected result**: the user sees predicted arrivals ordered in a clear, readable way.

### 4. Permission and error handling

1. Deny location permission and relaunch the app.
2. Trigger a retry after restoring access or connectivity.

**Expected result**: the app explains why the map cannot show nearby stops and offers a recoverable action.

