import Foundation

struct TransitVehiclePositionResponse: Codable, Hashable, Sendable {
    let referenceTime: String
    let lines: [TransitVehicleLinePosition]

    private enum CodingKeys: String, CodingKey {
        case referenceTime = "hr"
        case lines = "l"
    }
}

struct TransitLineVehiclePositionResponse: Codable, Hashable, Sendable {
    let referenceTime: String
    let positions: [TransitVehiclePosition]

    private enum CodingKeys: String, CodingKey {
        case referenceTime = "hr"
        case positions = "vs"
    }
}

struct TransitVehicleLinePosition: Codable, Hashable, Sendable, Identifiable {
    let code: String
    let lineCode: Int
    let direction: Int
    let origin: String
    let destination: String
    let vehicleCount: Int
    let vehicles: [TransitVehiclePosition]

    var id: Int { lineCode }

    private enum CodingKeys: String, CodingKey {
        case code = "c"
        case lineCode = "cl"
        case direction = "sl"
        case origin = "lt0"
        case destination = "lt1"
        case vehicleCount = "qv"
        case vehicles = "vs"
    }
}

struct TransitVehiclePosition: Codable, Hashable, Sendable, Identifiable {
    let prefix: String
    let accessible: Bool
    let capturedAt: String?
    let latitude: Double
    let longitude: Double

    var id: String { prefix }

    private enum CodingKeys: String, CodingKey {
        case prefix = "p"
        case accessible = "a"
        case capturedAt = "ta"
        case latitude = "py"
        case longitude = "px"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prefix = try container.decodeStringOrNumber(forKey: .prefix)
        accessible = try container.decode(Bool.self, forKey: .accessible)
        capturedAt = try container.decodeOptionalStringOrNumber(forKey: .capturedAt)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }
}
