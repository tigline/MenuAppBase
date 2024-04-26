//
//  OrderCheckResource.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/27.
//

import Foundation

struct OrderCheckResource:APIResource {
    typealias ModelType = Response<Bool>
    
    var path: String = "/pad/web/ipad/heartbeat"
    
    var method: HttpMethod = .POST
    
    var body: Data? {
        ["shopCode":shopCode,
        "orderKey":orderKey].toJSONData() ?? Data()
    }
    
    let shopCode:String
    let orderKey:String
}
