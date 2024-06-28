//
//  APIResource.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/14.
//

import Foundation
enum HttpMethod:String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
    case DELETE = "DELETE"
}

protocol APIResource:APIOptions {
    associatedtype ModelType: Codable
    
    var host: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    
}

protocol APIOptions {
    var parameter: [String: String]? { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
}

extension APIOptions {
    var parameter: [String: String]? { return nil }
    var body: Data? { return nil }
    var headers: [String: String]? { return nil }
}

extension APIResource {
    
    var host:String {
        #if DEBUG
            "https://sit-api.smartwe.jp"
        #else
            "https://api.smartwe.jp"
        #endif
    }
    
    func buildURLRequest() -> URLRequest {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headerss = headers {
            for header in headerss {
                urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        urlRequest.httpMethod = method.rawValue
        if let getBody = body {
            if let jsonString = String(data: getBody, encoding: .utf8) {
                print("send data: \(jsonString)")
            }
            urlRequest.httpBody = getBody
        }

        return urlRequest
    }
    
    private var url: URL {
        var url = URL(string:host)!
            .appending(path: path)
        
        guard let paramkeys = parameter else {return url}
        
        url.append(queryItems: paramkeys.compactMap({
                URLQueryItem(name: $0.key, value: $0.value)
            }))
        return url
    }
    
    

}
