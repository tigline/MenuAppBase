//
//  APISClient.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/06.
//

import Foundation

protocol APISClient {
    func get<Response: Decodable>(path: URL) async throws -> Response
    func post<Response: Decodable>(path: URL, body: Data) async throws -> Response
}


extension APISClient {
    func get<Response: Decodable>(point: SWEndpoint) async throws -> Response {
        try await get(path: point.path)
    }

    func post<Response: Decodable>(point: SWPostEndpoint) async throws -> Response {
        try await post(path: point.path, body: point.body)
    }
}

protocol SWEndpoint {
    var path:URL { get }
    
}

protocol SWPostEndpoint:SWEndpoint {
    var body:Data { get }
}


enum SmartWeGetEndPoint {
}

enum SmartWePostEndpoint {
    case active(machineCode: String)
    case category(shopCode: String, machineCode: String)
    case menu(shopCode: String, language: String)
}




//extension SmartWeGetEndPoint: SWEndpoint {
//    var path: URL {
//        switch self {
//        case .active(machineCode: let machineCode):
//            <#code#>
//        }
//    }
//}

extension SmartWePostEndpoint: SWPostEndpoint {
    
    private static let basePath = URL(string: "/wed/ipad")!
    
    var path: URL {
        switch self {
        case .active(machineCode: let machineCode):
            return Self.basePath.appendingPathComponent("activate")
        case .category(shopCode: let shopCode, machineCode: let machineCode):
            return Self.basePath.appendingPathComponent("category")
        case .menu(shopCode: let shopCode, language: let language):
            return Self.basePath.appendingPathComponent("index")
        }
    }
    
    var body: Data {
        switch self {
        
        case .active(machineCode: let machineCode):
            return ["machineCode":machineCode].toJSONData() ?? Data()
        case .category(shopCode: let shopCode, machineCode: let machineCode):
            return ["shopCode":shopCode,
                    "machineCode":machineCode].toJSONData() ?? Data()
        case .menu(shopCode: let shopCode, language: let language):
            return ["shopCode":shopCode,
                    "language":language].toJSONData() ?? Data()
        }
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    func toJSONData() -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return jsonData
        } catch {
            print("Error serializing dictionary to JSON: \(error)")
            return nil
        }
    }
}

