# Research

## 1. Location authorization for nearby stops

- **Decision**: Request location access only while the app is in use.
- **Rationale**: The app needs the user's current location to center the map and compute nearby stops, but it does not require background tracking.
- **Alternatives considered**: Always-on location was rejected because it adds privacy burden without a clear feature need.
- **Sources**: [Apple Core Location documentation](https://developer.apple.com/documentation/corelocation/cllocationmanager/requestwheninuseauthorization%28%29?language=swift)

## 2. Map presentation

- **Decision**: Present the user's location as the primary anchor on a MapKit map and render SPTrans stops as annotations around it.
- **Rationale**: MapKit already provides the native location and annotation experience needed for an iOS-only transit map.
- **Alternatives considered**: A list-only interface was rejected because the feature explicitly needs visual discovery of nearby points.
- **Sources**: [Apple MapKit user annotation documentation](https://developer.apple.com/documentation/mapkit/userannotation)

## 3. Live stop and line data

- **Decision**: Use SPTrans Olho Vivo for line lookup, stop lookup, and arrival predictions for the selected stop.
- **Rationale**: The official API exposes line search, stop search, and stop arrival endpoints that match the feature's user flow.
- **Alternatives considered**: A static stop dataset was rejected because it would not show live arrivals.
- **Sources**: [SPTrans API documentation](https://www.sptrans.com.br/desenvolvedores/api-do-olho-vivo-guia-de-referencia/documentacao-api/)

## 4. Definition of "nearby stops"

- **Decision**: Treat nearby stops as SPTrans stops that can be resolved from the available Olho Vivo stop data and filtered locally against the user's current map region and location.
- **Rationale**: The official documentation exposes stop search and stop-by-line data with coordinates, but it does not provide a dedicated radius search endpoint. A local proximity filter keeps the experience aligned with the available data.
- **Alternatives considered**: Citywide stop discovery by radius was rejected because the documented API does not expose a direct geospatial stop search.
- **Sources**: [SPTrans API documentation](https://www.sptrans.com.br/desenvolvedores/api-do-olho-vivo-guia-de-referencia/documentacao-api/), [Olho Vivo tutorial](https://olhovivo.sptrans.com.br/files/TutorialNovoOlhoVivo.pdf)

## 5. Stop detail content

- **Decision**: Show the stop name, identifying code, and the list of lines with their upcoming arrivals when a stop is selected.
- **Rationale**: The official tutorial shows the stop detail pattern centered on the stop and the lines approaching it, which is the most useful confirmation step for the user.
- **Alternatives considered**: Line-only detail was rejected because the selected point is the user's current context.
- **Sources**: [Olho Vivo tutorial](https://olhovivo.sptrans.com.br/files/TutorialNovoOlhoVivo.pdf)

