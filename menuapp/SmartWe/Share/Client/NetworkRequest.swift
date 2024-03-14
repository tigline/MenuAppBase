//
//  NetworkRequest.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/14.
//

import Foundation
protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) throws -> ModelType
    func execute() async throws -> ModelType
}

extension NetworkRequest {
    
    func send(_ request: URLRequest) async throws -> ModelType {
        let (data, response) = try await urlSession.data(for: request)
        try validate(response: response)
        return try decode(data)
    }
    
    var urlSession: URLSession {
        URLSession(configuration: URLSession.smartweConfiguration)
    }
    
    private func validate(response: URLResponse) throws {
        if let error = SmartWeError(response: response) {
            throw error
        }
    }
    
}
