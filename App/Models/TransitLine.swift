import Foundation

struct TransitLine: Codable, Hashable, Sendable, Identifiable {
    let code: Int
    let isCircular: Bool
    let number: String
    let direction: Int
    let serviceType: Int
    let origin: String
    let destination: String

    var id: Int { code }

    private enum CodingKeys: String, CodingKey {
        case code = "cl"
        case isCircular = "lc"
        case number = "lt"
        case direction = "sl"
        case serviceType = "tl"
        case origin = "tp"
        case destination = "ts"
    }
}

struct TransitLineSearchResponse: Codable, Hashable, Sendable {
    let lines: [TransitLine]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        lines = try container.decode([TransitLine].self)
    }
}
