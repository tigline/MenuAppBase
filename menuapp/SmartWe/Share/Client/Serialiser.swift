//
//  Serialiser.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/06.
//

import Foundation
actor Serialiser {

    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(decoder: JSONDecoder, encoder: JSONEncoder) {
        self.decoder = decoder
        self.encoder = encoder
    }


    func decode<T: Decodable>(_ data: Data) async throws -> T {
        let result: T
        do {
            if let dataString = String(data: data, encoding: .utf8) {
                print("ResponData: \(dataString)")
            }
            result = try decoder.decode(T.self, from: data)
        } catch let error {
            throw SmartWeError.decode(error)
        }

        return result
    }

    func encode<T: Encodable>(_ value: T) async throws -> Data {
        let result: Data
        do {
            result = try encoder.encode(value)
        } catch let error {
            throw SmartWeError.encode(error)
        }

        return result
    }


}
