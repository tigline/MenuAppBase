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
    let orderType:Int
    let tableNo:String
    let tableout:Bool
    let total:Int
    
    
    struct OrderLineList: Codable, Hashable {
        let lineId:Int
        let menuCode:Int
        let optioneList:[String]
        let qty:Int
    }
}
