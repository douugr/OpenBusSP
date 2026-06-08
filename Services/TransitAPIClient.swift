import Foundation

enum TransitAPIError: Error, LocalizedError, Equatable {
    case missingAccessToken
    case invalidBaseURL
    case invalidResponse
    case authenticationRejected
    case httpStatus(Int)
    case emptyQuery
    case transportFailed(String)
    case decodingFailed(String)

    var errorDescription: String? {
        switch self {
        case .missingAccessToken:
            return "A SPTrans access token is required."
        case .invalidBaseURL:
            return "The SPTrans base URL is invalid."
        case .invalidResponse:
            return "The SPTrans API returned an unexpected response."
        case .authenticationRejected:
            return "SPTrans authentication was rejected."
        case .httpStatus(let statusCode):
            return "SPTrans returned HTTP status \(statusCode)."
        case .emptyQuery:
            return "Search text cannot be empty."
        case .transportFailed(let message):
            return message
        case .decodingFailed(let message):
            return message
        }
    }
}

final class TransitAPIClient {
    struct Configuration: Sendable {
        let accessToken: String
        let baseURL: URL
        let session: URLSession

        init(
            accessToken: String,
            baseURL: URL = URL(string: "https://api.olhovivo.sptrans.com.br/v2.1")!,
            session: URLSession = .shared
        ) {
            self.accessToken = accessToken
            self.baseURL = baseURL
            self.session = session
        }
    }

    private let configuration: Configuration
    private let jsonDecoder: JSONDecoder
    private var isAuthenticated = false

    init(configuration: Configuration) {
        self.configuration = configuration
        jsonDecoder = JSONDecoder()
    }

    convenience init(
        accessToken: String,
        baseURL: URL = URL(string: "https://api.olhovivo.sptrans.com.br/v2.1")!,
        session: URLSession = .shared
    ) {
        self.init(configuration: Configuration(accessToken: accessToken, baseURL: baseURL, session: session))
    }

    func authenticate() async throws {
        guard !configuration.accessToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TransitAPIError.missingAccessToken
        }

        let responseData = try await performRawRequest(
            path: "/Login/Autenticar",
            method: "POST",
            queryItems: [URLQueryItem(name: "token", value: configuration.accessToken)],
            requiresAuthentication: false
        )

        let responseText = String(decoding: responseData, as: UTF8.self)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard responseText == "true" else {
            throw TransitAPIError.authenticationRejected
        }

        isAuthenticated = true
    }

    func searchLines(matching terms: String) async throws -> [TransitLine] {
        try await authenticateIfNeeded()
        let response: [TransitLine] = try await performDecodableRequest(
            path: "/Linha/Buscar",
            queryItems: [URLQueryItem(name: "termosBusca", value: normalizedQuery(terms))]
        )
        return response
    }

    func searchStops(matching terms: String) async throws -> [TransitStop] {
        try await authenticateIfNeeded()
        let response: [TransitStop] = try await performDecodableRequest(
            path: "/Parada/Buscar",
            queryItems: [URLQueryItem(name: "termosBusca", value: normalizedQuery(terms))]
        )
        return response
    }

    func searchStops(forLineCode lineCode: Int) async throws -> [TransitStop] {
        try await authenticateIfNeeded()
        let response: [TransitStop] = try await performDecodableRequest(
            path: "/Parada/BuscarParadasPorLinha",
            queryItems: [URLQueryItem(name: "codigoLinha", value: String(lineCode))]
        )
        return response
    }

    func fetchStopArrivals(stopCode: Int, lineCode: Int? = nil) async throws -> TransitStopArrivalResponse {
        try await authenticateIfNeeded()

        var queryItems = [URLQueryItem(name: "codigoParada", value: String(stopCode))]
        if let lineCode {
            queryItems.append(URLQueryItem(name: "codigoLinha", value: String(lineCode)))
        }

        return try await performDecodableRequest(
            path: "/Previsao/Parada",
            queryItems: queryItems
        )
    }

    func fetchLineArrivals(lineCode: Int) async throws -> TransitLineArrivalResponse {
        try await authenticateIfNeeded()
        return try await performDecodableRequest(
            path: "/Previsao/Linha",
            queryItems: [URLQueryItem(name: "codigoLinha", value: String(lineCode))]
        )
    }

    func fetchFleetPositions() async throws -> TransitVehiclePositionResponse {
        try await authenticateIfNeeded()
        return try await performDecodableRequest(path: "/Posicao")
    }

    func fetchLinePositions(lineCode: Int) async throws -> TransitLineVehiclePositionResponse {
        try await authenticateIfNeeded()
        return try await performDecodableRequest(
            path: "/Posicao/Linha",
            queryItems: [URLQueryItem(name: "codigoLinha", value: String(lineCode))]
        )
    }

    private func authenticateIfNeeded() async throws {
        if !isAuthenticated {
            try await authenticate()
        }
    }

    private func performDecodableRequest<T: Decodable>(
        path: String,
        method: String = "GET",
        queryItems: [URLQueryItem] = []
    ) async throws -> T {
        let data = try await performRawRequest(
            path: path,
            method: method,
            queryItems: queryItems,
            requiresAuthentication: true
        )

        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw TransitAPIError.decodingFailed(error.localizedDescription)
        }
    }

    private func performRawRequest(
        path: String,
        method: String,
        queryItems: [URLQueryItem],
        requiresAuthentication: Bool
    ) async throws -> Data {
        if requiresAuthentication {
            try await authenticateIfNeeded()
        }

        guard var components = URLComponents(url: configuration.baseURL, resolvingAgainstBaseURL: false) else {
            throw TransitAPIError.invalidBaseURL
        }

        components.path = components.path + path
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw TransitAPIError.invalidBaseURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 30

        do {
            let (data, response) = try await configuration.session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TransitAPIError.invalidResponse
            }
            guard 200..<300 ~= httpResponse.statusCode else {
                throw TransitAPIError.httpStatus(httpResponse.statusCode)
            }
            return data
        } catch let error as TransitAPIError {
            throw error
        } catch {
            throw TransitAPIError.transportFailed(error.localizedDescription)
        }
    }

    private func normalizedQuery(_ value: String) throws -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw TransitAPIError.emptyQuery
        }
        return trimmed
    }
}
