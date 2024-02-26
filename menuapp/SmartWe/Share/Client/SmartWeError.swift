//
//  SmartWeError.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/06.
//

import Foundation

public enum SmartWeError: Error {

    /// Network error.
    case network(Error)
    /// OK
    case ok
    /// Created
    case created
    /// Unauthorised.
    case unauthorized
    /// Forbidden
    case forbidden
    /// Not found.
    case notFound
    /// Unknown error.
    case unknown(Int)
    /// Data decode error.
    case decode(Error)
    /// Data encode error.
    case encode(Error)

}

extension SmartWeError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription
            
        case .ok:
            return "OK"
            
        case .created:
            return "Created"

        case .unauthorized:
            return "Unauthorised"
            
        case .forbidden:
            return "Forbidden"

        case .notFound:
            return "Not Found"

        case .unknown(let errorCode):
            return "Error code \(errorCode)"

        case .decode(let error):
            return error.localizedDescription
            
        case .encode(let error):
            return error.localizedDescription
        
        }
    }

}

