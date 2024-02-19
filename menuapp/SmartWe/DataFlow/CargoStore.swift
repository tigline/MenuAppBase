//
//  CargoStore.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/14.
//

import Foundation

@Observable
class CargoStore {
    let appService:AppService
    init(appService: AppService) {
        self.appService = appService
    }
    
    var shoppingCart:[GoodItem] = []
    
    var goodsCount:String {
        let count = shoppingCart.reduce(into: 0) { count, item in
            count += item.quantity
        }
        
        return "\(count)"
    }
    
    var subTotle:String {
        allTotle
    }
    
    var allTotle:String {
        let all = shoppingCart.reduce(0) { count, item in
            count + item.price * Double(item.quantity)
        }
        return "\(all)"
    }
    
    
    
    func addGood(_ menu:Menu, price:Double, options:[String] = []) {
        
        if let index = shoppingCart.firstIndex(where: {$0.menu.menuCode == menu.menuCode && $0.optionCodes == options}) {
            shoppingCart[index].quantity += 1
        } else {
            shoppingCart.append(GoodItem(id: shoppingCart.count,
                                         menu: menu,
                                         price: price,
                                         optionCodes: options,
                                         quantity: 1
                                        ))
        }
    }
    
    func addGood(_ item: GoodItem) {
        if let index = shoppingCart.firstIndex(where: {$0.menu.menuCode == item.menu.menuCode && $0.optionCodes == item.optionCodes}) {
            shoppingCart[index].quantity += 1
        } else {
            shoppingCart.append(item)
        }
    }
    
    func removeGood(_ item: GoodItem) {
        
        if let index = shoppingCart.firstIndex(where: {$0.menu.menuCode == item.menu.menuCode && $0.optionCodes == item.optionCodes}) {
            shoppingCart[index].quantity -= 1
            if shoppingCart[index].quantity == 0 {
                shoppingCart.remove(at: index)
            }
        }
    }
    
    
    
    func orderCart() async {
        
    }

    
    
}

extension [String] {
    
}

struct GoodItem: Identifiable {
    let id:Int
    let menu:Menu
    let price:Double
    var optionCodes:[String] = []
    
    var quantity:Int = 0
    
    var title:String {
        menu.mainTitle
    }
}


extension GoodItem {
    var moneyType:String {
        "¥"
    }
    var image:String {
        menu.homeImage
    }
    
    var table:Int {
        09
    }
    
    var showPrice:String {
        "\(price)"
    }
}
