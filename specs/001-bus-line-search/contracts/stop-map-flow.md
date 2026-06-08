# Stop Map Flow Contract

## Scope

This contract defines the user-facing behavior for the map screen and the stop detail flow in the iOS app.

## Map Screen States

### Initial

- The app asks for location access when the map experience starts.
- The map centers on the user's current location after permission is granted.
- Nearby SPTrans stops appear as annotations once they are available.

### Loading

- While the app is resolving nearby stops or refreshing live data, a loading state is shown.
- The user can keep interacting with the map while the data loads.

### Empty

- If no nearby stops are available for the current map area, the app shows a clear empty-state message.
- The message explains that the user can move the map or try a broader area.

### Error

- If location access is denied or data cannot be loaded, the app shows a human-readable error.
- The error state includes a retry action when the failure is recoverable.

## Stop Selection Contract

- Tapping a stop opens a detail sheet or panel anchored to that stop.
- The detail view shows the stop name, stop identifier, and the lines serving the stop.
- Lines are ordered by predicted arrival time when arrival data is available.
- Each line row shows enough information for the user to recognize the service quickly.

## Acceptance Expectations

- A selected stop always maps to a single stop identity.
- The lines shown for a stop belong to that stop, not to a nearby stop.
- The user can return to the map without losing the current region.

