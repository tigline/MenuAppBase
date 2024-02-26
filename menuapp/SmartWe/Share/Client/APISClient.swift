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
        return try await get(path: point.path)
    }

    func post<Response: Decodable>(point: SWPostEndpoint) async throws -> Response {
        return try await post(path: point.path, body: point.body)
    }
}

protocol SWEndpoint {
    var path:URL { get }
    
}

protocol SWPostEndpoint:SWEndpoint {
    var body:Data { get }
}


enum SmartWeGetEndPoint {
    case callWaiter(machineCode: String, tableNo:String)
}

enum SmartWePostEndpoint {
    case active(machineCode: String)
    case category(shopCode: String, machineCode: String)
    case menu(shopCode: String, language: String)
    case order(_ body:Data)
    case bindTable(shopCode: String, tableNo:String)
    case checkOrder(shopCode: String, orderKey:String)
}




extension SmartWeGetEndPoint: SWEndpoint {
    private static let basePath = URL(string: "/pad/web/ipad")!
    var path: URL {
        switch self {
        case .callWaiter(machineCode: let machineCode, tableNo: let tableNo):
            return Self.basePath.appendingPathComponent("call")
                .appendingQueryItem(name: "machineCode", value: machineCode)
                .appendingQueryItem(name: "tableNo", value: tableNo)
        }
    }
}

extension SmartWePostEndpoint: SWPostEndpoint {
    
    private static let basePath = URL(string: "/pad/web/ipad")!
    
    var path: URL {
        switch self {
        case .active(machineCode: _):
            return Self.basePath.appendingPathComponent("activate")
        case .category(shopCode: _, machineCode: _):
            return Self.basePath.appendingPathComponent("category")
        case .menu(shopCode: _, language: _):
            return Self.basePath.appendingPathComponent("index")
        case .order(_):
            return Self.basePath.appendingPathComponent("order")
        case .bindTable(_, _):
            return Self.basePath.appendingPathComponent("table/list")
        case .checkOrder(_, _):
            return Self.basePath.appendingPathComponent("check")
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
        case .order(body: let body):
            return body
        case .bindTable(shopCode: let shopCode, tableNo: let tableNo):
            return ["shopCode":shopCode,
                    "tableNo":tableNo].toJSONData() ?? Data()
        case .checkOrder(shopCode: let shopCode, orderKey: let orderKey):
            return ["shopCode":shopCode,
                    "orderKey":orderKey].toJSONData() ?? Data()
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

