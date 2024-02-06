//
//  APISClient.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/06.
//

import Foundation

protocol APISClient {
    func get<Response: Decodable>(path: URLRequest) async throws -> Response
    func post<Response: Decodable>(body: URLRequest) async throws -> Response
}


extension APISClient {
    func get<Response: Decodable>(point: SWEndpoint) async throws -> Response {
        try await get(path: point.request)
    }

    func post<Response: Decodable>(point: SWEndpoint) async throws -> Response {
        try await post(body: point.request)
    }
}

protocol SWEndpoint {
    var request:URLRequest { get }
}

enum SmartWeGetPoint {
    case call
}

enum SmartWePostPoint {
    case active(machineCode: String)
    case category(shopCode: String, machineCode: String)
    case menu(shopCode: String, machineCode: String, categoryCode: String)
}




