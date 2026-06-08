import Combine
import Foundation

@MainActor
final class AppDependencies: ObservableObject {
    let tokenVault: SPTransTokenVault
    let transitAPIClient: TransitAPIClient?

    init(tokenVault: SPTransTokenVault? = nil) {
        let resolvedTokenVault = tokenVault ?? .shared
        self.tokenVault = resolvedTokenVault

        try? resolvedTokenVault.bootstrapIfNeeded()
        transitAPIClient = try? TransitAPIClient(tokenVault: resolvedTokenVault)
    }
}
