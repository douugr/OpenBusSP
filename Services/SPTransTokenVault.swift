import Foundation

final class SPTransTokenVault {
    static let shared = SPTransTokenVault()

    private let secretVault: EncryptedSecretVault

    init(secretVault: EncryptedSecretVault = EncryptedSecretVault(configuration: .init(
        keychainItem: .init(service: "com.openbussp.sptrans", account: "encryption-key"),
        ciphertextKey: "com.openbussp.sptrans.ciphertext"
    ))) {
        self.secretVault = secretVault
    }

    func install(accessToken: String) throws {
        try secretVault.store(accessToken)
    }

    func installIfNeeded(accessToken: String) throws {
        if try currentAccessToken() == nil {
            try install(accessToken: accessToken)
        }
    }

    func currentAccessToken() throws -> String? {
        try secretVault.load()
    }

    func clear() throws {
        try secretVault.clear()
    }

    func bootstrapIfNeeded(fromInfoPlistKey key: String = "SPTRANS_ACCESS_TOKEN") throws {
        guard let rawValue = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            return
        }

        let accessToken = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !accessToken.isEmpty else {
            return
        }

        try installIfNeeded(accessToken: accessToken)
    }
}
