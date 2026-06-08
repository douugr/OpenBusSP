import Foundation

extension KeyedDecodingContainer {
    func decodeStringOrNumber(forKey key: Key) throws -> String {
        if let stringValue = try decodeIfPresent(String.self, forKey: key) {
            return stringValue
        }

        if let integerValue = try decodeIfPresent(Int.self, forKey: key) {
            return String(integerValue)
        }

        if let doubleValue = try decodeIfPresent(Double.self, forKey: key) {
            return String(doubleValue)
        }

        throw DecodingError.valueNotFound(
            String.self,
            .init(
                codingPath: codingPath + [key],
                debugDescription: "Expected a string or numeric value for key \(key.stringValue)."
            )
        )
    }

    func decodeOptionalStringOrNumber(forKey key: Key) throws -> String? {
        if let stringValue = try decodeIfPresent(String.self, forKey: key) {
            return stringValue
        }

        if let integerValue = try decodeIfPresent(Int.self, forKey: key) {
            return String(integerValue)
        }

        if let doubleValue = try decodeIfPresent(Double.self, forKey: key) {
            return String(doubleValue)
        }

        return nil
    }
}
