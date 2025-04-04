//
//  MenuStore.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/14.
//

import Observation
import UIKit
import SwiftUI

@Observable
class MenuStore {
    var cartIconGlobalFrame: CGRect = .zero
    
    let appService:AppService
    
    var shopMenuInfo:ShopMenuInfo?
    
    var menuList:[MenuCategory] {
        shopMenuInfo?.categoryVoList ?? []
    }
    
    var catagorys:[String] {
        menuList.map({$0.categoryName})
    }
    
    var menuCatagorys:[String] {
        catagorys + ["booking_history","shopping_car","setting"]
    }
    
    var selectBarIndex:Int = 0 {
        didSet {
            
        }
    }
    
    var catagory:String? {
        if menuCatagorys.count > 0 {
            if selectBarIndex == -1 {
                return ""
            }
            if selectBarIndex >= menuCatagorys.count {
                return menuCatagorys[0]
            }
            return menuCatagorys[selectBarIndex]
        }
        return ""
    }
    
    func updateTab(_ tap:String) {
        if let index = menuCatagorys.firstIndex(where: {$0 == tap}) {
            selectBarIndex = index
        } else {
            selectBarIndex = -1
        }
    }
    
    var curMenuInfo:MenuCategory? {
        if let item = menuList.first(where: {$0.categoryName == catagory}) {
            return item
        } else if menuList.count > 0 {
            return menuList[0]
        }
        return nil
    }
    
    func getCurrentMenu(_ menu:String) -> MenuCategory? {
        return menuList.first(where: {$0.categoryName == catagory})
    }
    
    var selectMenuItem:Menu?
    
    func selectMenuItem(_ menu:Menu) {
        selectMenuItem = menu
    }
    
    
    init(appService: AppService) {
        self.appService = appService
    }
    
    @MainActor func load(shopCode: String, machineCode:String, language: String) async throws {
        
        do {
            let result = try await appService.menuItemList(shopCode: shopCode, machineCode: machineCode, language: language)
            if result.code == 200 {
                shopMenuInfo = result.data
            } else {
                throw NSError(domain: "Loading", code: 0, userInfo: [NSLocalizedDescriptionKey:"Loading Failured"])
            }
        } catch {
            //print("Failed to load menu info: \(error.localizedDescription)")
            throw error
        }
    }
    
    func callWaiter(_ machineCode:String, _ tableNo:String, _ handleResult:(LocalizedStringKey)->Void) async {
        
        do {
            let result = try await appService.callWaiter(machineCode, tableNo)
            if result.data {
                print("call waiter success")
                handleResult("call_waiter_success")
            }
        } catch {
            print("callWaiter \(error.localizedDescription)")
            handleResult("callWaiter \(error.localizedDescription)")
            
        }
    }
    
    func bindTableNo(_ shopCode:String, _ tableNo:String) async {
        do {
            let result = try await appService.bindTableNo(shopCode, tableNo)
            if result.code == 200 {
                print("bindTableNo success")
            }
        } catch {
            print("bindTableNo \(error)")
        }
    }
    
    func checkOrder(_ shopCode:String, orderKey:String) async {
        do {
            let result = try await appService.checkOrder(shopCode, orderKey)
            if result.code == 200 {
                print("checkOrder success")
            }
        } catch {
            print("checkOrder \(error)")
        }
    }
    
}

extension MenuStore {
    func binding<Value>(
        for keyPath: KeyPath<MenuStore, Value>,
        toFunction: @escaping (Value) -> Void
    ) -> Binding<Value> {
        Binding<Value>(
            get: { self[keyPath: keyPath] },
            set: { toFunction($0) }
        )
    }
}
