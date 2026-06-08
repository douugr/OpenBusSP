# Data Model

## TransitStop

- **Purpose**: Represents a bus stop that can appear on the map and be selected by the user.
- **Fields**:
  - `code`: unique identifier from SPTrans.
  - `name`: display name shown in the UI.
  - `address`: human-readable location string when available.
  - `latitude`: geographic coordinate.
  - `longitude`: geographic coordinate.
  - `distanceFromUser`: computed proximity value used for sorting.
- **Validation Rules**:
  - `code` must be present and unique within the active result set.
  - `latitude` and `longitude` must be valid coordinates before the stop can be shown on the map.
  - `name` must be present for selection and accessibility labeling.

## TransitLine

- **Purpose**: Represents a bus line associated with a stop or search result.
- **Fields**:
  - `code`: unique line identifier from SPTrans.
  - `number`: public line number shown to users.
  - `name`: destination or descriptive label.
  - `direction`: direction or sense information when available.
  - `serviceStatus`: operational state shown in the stop detail view when provided.
- **Validation Rules**:
  - `code` must be present and unique within the active result set.
  - `number` must be present so the user can compare lines quickly.

## StopArrival

- **Purpose**: Represents a predicted arrival for a specific line at a selected stop.
- **Fields**:
  - `stopCode`: reference to `TransitStop`.
  - `lineCode`: reference to `TransitLine`.
  - `vehiclePrefix`: vehicle identifier when the service returns it.
  - `arrivalTime`: predicted arrival time shown in the detail view.
  - `accessible`: accessibility flag when provided by the service.
- **Validation Rules**:
  - Every arrival record must reference both one stop and one line.
  - Arrival times must be displayed in chronological order.
  - Duplicate arrival rows for the same stop-line pair must be merged or suppressed.

## NearbyStopQuery

- **Purpose**: Represents the user's current location and the active map search area.
- **Fields**:
  - `userLatitude`: current user latitude.
  - `userLongitude`: current user longitude.
  - `searchRadius`: radius used to shortlist visible stops.
  - `mapRegion`: current visible region on the map.
- **Validation Rules**:
  - The query is only valid after the user has granted location access.
  - The search radius must stay within a configured app default so the map remains legible.

## Relationships

- A `TransitStop` can have many `StopArrival` records.
- A `TransitLine` can appear in many `StopArrival` records across different stops.
- `NearbyStopQuery` is transient view state and is not persisted as domain data.

