//
//  APIRequest.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/14.
//

import Foundation
class APIRequest<Resource: APIResource> {
    let resource: Resource

    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {
    func decode(_ data: Data) throws -> Resource.ModelType {
        
        do {
            if let dataString = String(data: data, encoding: .utf8) {
                print("ResponData: \(dataString)")
            }
            let reponse = try JSONDecoder.apiDecoder
                .decode(Resource.ModelType.self, from: data)
            return reponse
        } catch let error {
            throw SmartWeError.decode(error)
        }
        
        
    }
    

    func execute() async throws -> Resource.ModelType {
        try await send(resource.buildURLRequest())
    }
}
