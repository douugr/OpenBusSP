import Foundation
import CryptoKit

enum EncryptedSecretVaultError: Error, LocalizedError, Equatable {
    case keyUnavailable
    case encryptionFailed
    case decryptionFailed
    case invalidCiphertext

    var errorDescription: String? {
        switch self {
        case .keyUnavailable:
            return "The encryption key is unavailable."
        case .encryptionFailed:
            return "The secret could not be encrypted."
        case .decryptionFailed:
            return "The secret could not be decrypted."
        case .invalidCiphertext:
            return "The encrypted secret is invalid."
        }
    }
}

final class EncryptedSecretVault {
    struct Configuration: Sendable {
        let keychainItem: KeychainService.Item
        let ciphertextKey: String
    }

    private let keychain: KeychainService
    private let configuration: Configuration

    init(
        keychain: KeychainService = KeychainService(),
        configuration: Configuration
    ) {
        self.keychain = keychain
        self.configuration = configuration
    }

    func store(_ secret: String) throws {
        guard let secretData = secret.data(using: .utf8) else {
            throw EncryptedSecretVaultError.encryptionFailed
        }

        let key = try loadOrCreateKey()
        let sealedBox = try AES.GCM.seal(secretData, using: key)
        guard let combined = sealedBox.combined else {
            throw EncryptedSecretVaultError.encryptionFailed
        }
        UserDefaults.standard.set(combined.base64EncodedString(), forKey: configuration.ciphertextKey)
    }

    func load() throws -> String? {
        guard let encodedCiphertext = UserDefaults.standard.string(forKey: configuration.ciphertextKey) else {
            return nil
        }

        guard let ciphertext = Data(base64Encoded: encodedCiphertext) else {
            throw EncryptedSecretVaultError.invalidCiphertext
        }

        let key = try loadOrCreateKey()
        let sealedBox = try AES.GCM.SealedBox(combined: ciphertext)
        let plaintext = try AES.GCM.open(sealedBox, using: key)

        guard let secret = String(data: plaintext, encoding: .utf8) else {
            throw EncryptedSecretVaultError.decryptionFailed
        }

        return secret
    }

    func clear() throws {
        UserDefaults.standard.removeObject(forKey: configuration.ciphertextKey)
        try keychain.deleteItem(configuration.keychainItem)
    }

    private func loadOrCreateKey() throws -> SymmetricKey {
        if let storedKey = try keychain.readData(for: configuration.keychainItem) {
            return SymmetricKey(data: storedKey)
        }

        let key = SymmetricKey(size: .bits256)
        let rawKeyData = key.withUnsafeBytes { Data($0) }
        try keychain.saveData(rawKeyData, for: configuration.keychainItem)
        return key
    }
}
