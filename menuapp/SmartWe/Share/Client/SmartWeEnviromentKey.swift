//
//  SmartWeEnviromentKey.swift
//  SmartWe
//
//  Created by Aaron on 2024/2/6.
//

import Foundation
import SwiftUI

struct SmartWeKey: EnvironmentKey {
    static var defaultValue = AppService.appDefault
}

extension EnvironmentValues {
    var smartwe: AppService {
        get { self[SmartWeKey.self] }
        set { self[SmartWeKey.self] = newValue }
    }
}

extension AppService {

    static let appDefault = AppService(apisClient: SmartWeClient(apiKey: "",
                                                                 baseURL: serverURL,
                                                                 urlSession: URLSession(configuration: URLSession.smartweConfiguration),
                                                                 serialiser: Serialiser(decoder: .smartWeDecoder,encoder: .smartWeEncoder)))
}

extension URLSession {
    static var smartweConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache.urlCache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return configuration
    }
}

extension URLCache {
    static let urlCache = URLCache(memoryCapacity: 0, diskCapacity: 1024 * 1024 * 100)
}

extension JSONDecoder {

    static var smartWeDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(.theDatabase)
        return decoder
    }

}

extension JSONEncoder {
    static var smartWeEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(.theDatabase)
        return encoder
    }
}

extension DateFormatter {

    static var theDatabase: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

}
