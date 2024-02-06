//
//  Response.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/06.
//

import Foundation

struct Response<T: Codable>: Codable {
    let code: Int
    let data: T
    let msg: String
}
