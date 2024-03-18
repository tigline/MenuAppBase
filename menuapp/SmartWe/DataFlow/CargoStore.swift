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
    
    func updateTableNumber(_ number:String = "19") async {
        try? await coreDataStack.updateCargoKeyValue(key: "tableNo", value: number)
    }
    
    func deleteAll(_ tableNumber:String) {
        try? coreDataStack.batchDeleteDataWithTableNumber(tableNumber)
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
    
    func cleanShoppingCar(table:String) async throws {
        try coreDataStack.batchDeleteDataWithTableNumber(table)
    }
    
    
    func sendCarToOrder(shoppingCart:[CargoItem],
                        language:String,
                        machineCode:String,
                        orderType:Int = 0,
                        tableNo:String,
                        takeout:Bool = false,
                        totalPrice:String,
                        errorHandle:(Error?)->Void
    ) async {
        showOrderAnimate = true
        
        let orderLineList = shoppingCart.map { item in
            if item.options == nil {
                OrderLineList(menuCode: item.menuCode ?? "",
                              qty: Int(item.quantity))
            } else {
                OrderLineList(menuCode: item.menuCode ?? "",
                              optionList: item.options?.split(separator: ",").map { String($0) },
                              qty: Int(item.quantity))
            }
        }
        
        let order = Order(language: language,
                          machineCode: machineCode,
                          orderLineList: orderLineList,
                          orderType: orderType,
                          tableNo: tableNo,
                          takeout: takeout,
                          total: totalPrice
        )
        
        
        do {
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Optional: Make the output easier to read
            let jsonData = try encoder.encode(order)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
            
            let result = try await appService.sendOrder(jsonData)
            showOrderAnimate = false
            if result.code == 200 {
                errorHandle(nil)
            } else {
                errorHandle(nil)
            }
            
        } catch {
            showOrderAnimate = false
            print("Error encoding or send order: \(error)")
            errorHandle(error)
        }
        
        
    }

    
    
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

    var table:String? {
        AppConfiguration.share.tableNo
    }
    
    var showPrice:String {
        "\(price)"
    }
}
