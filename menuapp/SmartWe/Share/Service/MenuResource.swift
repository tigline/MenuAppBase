//
//  MenuResource.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/14.
//

import Foundation

struct MenuResource: APIResource {
    typealias ModelType = Response<ShopMenuInfo>
    
    var path: String = "/pad/web/ipad/index"
    
    var method: HttpMethod = .POST
    
    var body: Data? {
        ["shopCode":shopCode,
        "machineCode":machineCode].toJSONData() ?? Data()
    }
    
    let shopCode:String
    let machineCode:String

}
