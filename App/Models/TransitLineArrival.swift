import Foundation

struct TransitLineArrivalResponse: Codable, Hashable, Sendable {
    let referenceTime: String
    let stops: [TransitLineArrivalStop]

    private enum CodingKeys: String, CodingKey {
        case referenceTime = "hr"
        case stops = "ps"
    }
}

struct TransitLineArrivalStop: Codable, Hashable, Sendable, Identifiable {
    let code: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let vehicles: [TransitArrivalVehicle]

    var id: Int { code }

    private enum CodingKeys: String, CodingKey {
        case code = "cp"
        case name = "np"
        case latitude = "py"
        case longitude = "px"
        case vehicles = "vs"
    }
}
