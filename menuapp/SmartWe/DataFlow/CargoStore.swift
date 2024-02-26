//
//  CargoStore.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/14.
//

import Foundation
import SwiftUI

@Observable
class CargoStore {
    let appService:AppService
    
    let coreDataStack = CoreDataStack.shared
    
    init(appService: AppService) {
        self.appService = appService
    }
    
    var showOrderAnimate: Bool = false
    
    func toggleAnimate(_ value:Bool) {
        showOrderAnimate = value
    }
    
    func addGood(_ menu:Menu, price:Double, options:[String] = []) {
        
        
        let goodItem = GoodItem(id: 0,
                                menuCode: menu.menuCode,
                                image: menu.homeImage,
                                title: menu.mainTitle,
                                price: price,
                                optionCodes: options
                               )
        
        coreDataStack.updateCargoItem(menuCode: goodItem.menuCode, item: goodItem)
    }
    
    func addGood(_ item: CargoItem) {
//        if let index = shoppingCart.firstIndex(where: {$0.menuCode == item.menuCode && $0.optionCodes == item.optionCodes}) {
//            shoppingCart[index].quantity += 1
//        } else {
//            shoppingCart.append(item)
//        }
        
        coreDataStack.updateCargoItem(menuCode: item.menuCode ?? "")
    }
    
    func removeGood(_ item: CargoItem) {
        do {
            try coreDataStack.deleteDataWithMenuCode(menuCode: item.menuCode ?? "")
        } catch {
            print("removeGood error \(error.localizedDescription)")
        }
        
//        if let index = shoppingCart.firstIndex(where: {$0.menuCode == item.menuCode && $0.optionCodes == item.optionCodes}) {
//            shoppingCart[index].quantity -= 1
//            if shoppingCart[index].quantity == 0 {
//                shoppingCart.remove(at: index)
//            }
//        }
    }
    
    
    
    func sendCarToOrder(shoppingCart:[CargoItem],
                        language:String,
                        machineCode:String,
                        orderType:Int = 0,
                        tableNo:String = "08",
                        takeout:Bool = false,
                        errorHandle:(Error)->Void
    ) async {
        showOrderAnimate = true
        
        let orderLineList = shoppingCart.map { item in
            OrderLineList(lineId: "10101010",
                          menuCode: machineCode,
                          optioneList: [],
                          qty: 0)
        }
        
        let order = Order(language: language,
                          machineCode: machineCode,
                          orderLineList: orderLineList,
                          orderType: orderType,
                          tableNo: tableNo,
                          tableout: takeout,
                          total: shoppingCart.count)
        
        
        do {
            let bodyData = try JSONEncoder().encode(order)
            let result = try await appService.sendOrder(bodyData)
            showOrderAnimate = false
            if result.code == 200 {
                //shoppingCart.removeAll()
                try coreDataStack.batchDeleteDataWithTableNumber(tableNo)
            }
        } catch {
            showOrderAnimate = false
            print("Error encoding or send order: \(error)")
            errorHandle(error)
        }
        
        
    }

    
    
}

extension [String] {
    
}

struct GoodItem: Identifiable {
    let id:Int
    let menuCode:String
    let image:String
    let title:String
    let price:Double
    var optionCodes:[String] = []
    
    var quantity:Int = 1
    

}


extension GoodItem {
    var moneyType:String {
        "¥"
    }

    var table:String {
        "09"
    }
    
    var showPrice:String {
        "\(price)"
    }
}
