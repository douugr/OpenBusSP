import Combine
import Foundation

@MainActor
final class AppDependencies: ObservableObject {
    let tokenVault: SPTransTokenVault
    let transitAPIClient: TransitAPIClient?

    init(tokenVault: SPTransTokenVault = .shared) {
        self.tokenVault = tokenVault

        try? tokenVault.bootstrapIfNeeded()
        transitAPIClient = try? TransitAPIClient(tokenVault: tokenVault)
    }
}
