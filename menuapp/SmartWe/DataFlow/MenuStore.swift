//
//  MenuStore.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/14.
//

import Observation

@Observable
class MenuStore {
    
    let appService:AppService
    
    var shopMenuInfo:ShopMenuInfo?
    
    var menuList:[MenuCategory] {
        shopMenuInfo?.categoryVoList ?? []
    }
    
    var catagorys:[String] {
        menuList.map({$0.categoryName})
    }
    
    
    
    init(appService: AppService) {
        self.appService = appService
    }
    
    func load(shopCode: String, language: String) async {
        do {
            let result = try await appService.menuItemList(shopCode: shopCode, language: language)
            if result.code == 200 {
                shopMenuInfo = result.data
            }
        } catch {
            print("Failed to load menu info: \(error)")
        }
    }
    
    
    
    
}


