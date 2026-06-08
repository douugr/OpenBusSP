import Foundation

struct StopArrival: Codable, Hashable, Sendable, Identifiable {
    let lineNumber: String
    let lineCode: Int
    let direction: Int
    let origin: String
    let destination: String
    let vehicleCount: Int
    let vehicles: [TransitArrivalVehicle]

    var id: Int { lineCode }

    private enum CodingKeys: String, CodingKey {
        case lineNumber = "c"
        case lineCode = "cl"
        case direction = "sl"
        case origin = "lt0"
        case destination = "lt1"
        case vehicleCount = "qv"
        case vehicles = "vs"
    }
}

struct TransitArrivalVehicle: Codable, Hashable, Sendable, Identifiable {
    let prefix: String
    let arrivalTime: String
    let accessible: Bool
    let capturedAt: String?
    let latitude: Double
    let longitude: Double

    var id: String { prefix }

    private enum CodingKeys: String, CodingKey {
        case prefix = "p"
        case arrivalTime = "t"
        case accessible = "a"
        case capturedAt = "ta"
        case latitude = "py"
        case longitude = "px"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prefix = try container.decodeStringOrNumber(forKey: .prefix)
        arrivalTime = try container.decode(String.self, forKey: .arrivalTime)
        accessible = try container.decode(Bool.self, forKey: .accessible)
        capturedAt = try container.decodeOptionalStringOrNumber(forKey: .capturedAt)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }
}

struct TransitStopArrivalResponse: Codable, Hashable, Sendable {
    let referenceTime: String
    let stop: TransitStop
    let arrivals: [StopArrival]

    private enum CodingKeys: String, CodingKey {
        case referenceTime = "hr"
        case stop = "p"
    }

    private enum StopCodingKeys: String, CodingKey {
        case arrivals = "l"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        referenceTime = try container.decode(String.self, forKey: .referenceTime)
        stop = try container.decode(TransitStop.self, forKey: .stop)

        let stopContainer = try container.nestedContainer(keyedBy: StopCodingKeys.self, forKey: .stop)
        arrivals = try stopContainer.decode([StopArrival].self, forKey: .arrivals)
    }
}
