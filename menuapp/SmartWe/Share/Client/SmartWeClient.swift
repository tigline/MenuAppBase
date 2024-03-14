//
//  SmartWeClient.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/06.
//

import Foundation


final actor SmartWeClient: APISClient {

    private let apiKey: String
    private let baseURL: URL
    private let urlSession: URLSession
    private let serialiser: Serialiser

    init(apiKey: String, baseURL: URL, urlSession: URLSession, serialiser: Serialiser) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.serialiser = serialiser
    }

    func get<Response: Decodable>(path: URL) async throws -> Response {
        let urlRequest = buildURLRequest(for: path)

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await urlSession.data(for: urlRequest)
        } catch {
            throw SmartWeError.network(error)
        }

        try validate(response: response)
        return try await serialiser.decode(data)
    }

    func post<Response: Decodable>(path: URL, body: Data) async throws -> Response {
        //let url = urlFromPath(path)
        var urlRequest = buildURLRequest(for: path)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await urlSession.data(for: urlRequest)
        } catch {
            throw SmartWeError.network(error)
        }

        try validate(response: response)
        return try await serialiser.decode(data)
    }

}

extension SmartWeClient {

    private func buildURLRequest(for path: URL) -> URLRequest {
        let url = urlFromPath(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }

    private func urlFromPath(_ path: URL) -> URL {
        guard var urlComponents = URLComponents(url: path, resolvingAgainstBaseURL: true) else {
            return path
        }

        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = "\(baseURL.path)\(urlComponents.path)"

        return urlComponents.url!
//            .appendingAPIKey(apiKey)
//            .appendingLanguage()
    }

    private func validate(response: URLResponse) throws {
        if let tmdbError = SmartWeError(response: response) {
            throw tmdbError
        }
    }

}

extension SmartWeError {

    init?(response: URLResponse) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        print("statusCode = \(statusCode)")
        guard statusCode != 200 && statusCode != 201 else {
            return nil
        }

        switch statusCode {
        case 401:
            self = .unauthorized

        case 404:
            self = .notFound
        
        case 403:
            self = .forbidden

        default:
            self = .unknown(statusCode)
        }
    }

}
