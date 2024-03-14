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
    
    var currentError:String?
    
    init(service:AppService) {
        self.service = service
    }
    
    func orderList(machineCode:String, handleError:(String?)->Void) async {
        
        do {
            let result = try await service.orderDetail(machineCode)
            if result.code == 200 {
                
                
                handleError(nil)
            } else {
                handleError("Load Failied")
            }
            
        } catch {
            currentError = error.localizedDescription
            print("Error encoding or send order: \(error)")
            handleError(error.localizedDescription)
        }

         
    }
    
}

struct Order: Codable, Hashable {
    let language:String
    let machineCode:String
    let orderLineList:[OrderLineList]
    var orderType:Int?
    var tableNo:String?
    var takeout:Bool?
    let total:String
    
}
struct OrderLineList: Codable, Hashable {
    var lineId:String?
    let menuCode:String
    var optionList:[String]?
    let qty:Int
}
