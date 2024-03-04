//
//  OrderStore.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/14.
//

import Observation

@Observable
class OrderStore {
    let service:AppService
    var orderList:[Order] = []
    var currentOrder:Order?
    
    init(service:AppService) {
        self.service = service
    }
    
}

struct Order: Codable, Hashable {
    let language:String
    let machineCode:String
    let orderLineList:[OrderLineList]
    var orderType:Int?
    var tableNo:String?
    var tableout:Bool?
    let total:Int
    
}
struct OrderLineList: Codable, Hashable {
    var lineId:String?
    let menuCode:String
    var optioneList:[String]?
    let qty:Int
}
