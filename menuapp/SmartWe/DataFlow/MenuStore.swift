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
    
    var selectionIndex:Int = 0
    
    var menuList:[MenuCategory] {
        shopMenuInfo?.categoryVoList ?? []
    }
    
    var catagorys:[String] {
        menuList.map({$0.categoryName})
    }
    
    var catagory:String {
        return catagorys[selectionIndex]
    }
    
    var curMenuInfo:MenuCategory {
        return menuList.first(where: {$0.categoryName == catagory})!
    }
    
//    var selectItemOptions:(String)->Menu? = { code in
//        
//        return curMenuInfo.menuVoList.first(where: {$0.menuCode == code})
//    }
    
    
    
    
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


