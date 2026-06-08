import Foundation

struct TransitStop: Codable, Hashable, Sendable, Identifiable {
    let code: Int
    let name: String
    let address: String?
    let latitude: Double
    let longitude: Double

    var id: Int { code }

    private enum CodingKeys: String, CodingKey {
        case code = "cp"
        case name = "np"
        case address = "ed"
        case latitude = "py"
        case longitude = "px"
    }
}

struct TransitStopSearchResponse: Codable, Hashable, Sendable {
    let stops: [TransitStop]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        stops = try container.decode([TransitStop].self)
    }
}
