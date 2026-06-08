import Foundation
import Security

enum KeychainServiceError: Error, LocalizedError, Equatable {
    case unexpectedStatus(OSStatus)
    case invalidData
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .unexpectedStatus(let status):
            return "Keychain returned status \(status)."
        case .invalidData:
            return "Keychain data is invalid."
        case .encodingFailed:
            return "Keychain data could not be encoded."
        }
    }
}

final class KeychainService {
    struct Item: Sendable, Hashable {
        let service: String
        let account: String
    }

    func readData(for item: Item) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: item.service,
            kSecAttrAccount as String: item.account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                throw KeychainServiceError.invalidData
            }
            return data
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainServiceError.unexpectedStatus(status)
        }
    }

    func saveData(_ data: Data, for item: Item, accessible: CFString = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly) throws {
        let baseQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: item.service,
            kSecAttrAccount as String: item.account,
        ]

        let updateAttributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: accessible,
        ]

        let status = SecItemUpdate(baseQuery as CFDictionary, updateAttributes as CFDictionary)

        if status == errSecSuccess {
            return
        }

        if status == errSecItemNotFound {
            var addQuery = baseQuery
            addQuery[kSecValueData as String] = data
            addQuery[kSecAttrAccessible as String] = accessible

            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw KeychainServiceError.unexpectedStatus(addStatus)
            }
            return
        }

        throw KeychainServiceError.unexpectedStatus(status)
    }

    func deleteItem(_ item: Item) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: item.service,
            kSecAttrAccount as String: item.account,
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainServiceError.unexpectedStatus(status)
        }
    }
}
