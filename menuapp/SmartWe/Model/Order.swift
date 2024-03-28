//
//  Order.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/18.
//

import Foundation
struct Order: Codable, Hashable {
    let language:String
    let shopCode:String
    let machineCode:String
    let orderLineList:[OrderLineList]
    var orderType:Int?
    var orderKey:String?
    var takeout:Bool?
    let total:String
    
}
struct OrderLineList: Codable, Hashable {
    var lineId:String?
    let menuCode:String
    var optionList:[String]?
    let qty:Int
}
