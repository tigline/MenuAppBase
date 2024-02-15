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
    
    var menuOptionState:MenuOptionState?
    
    var menuList:[MenuCategory] {
        shopMenuInfo?.categoryVoList ?? []
    }
    
    var catagorys:[String] {
        menuList.map({$0.categoryName})
    }
    
    var catagory:String = ""
    
    var curMenuInfo:MenuCategory {
        return menuList.first(where: {$0.categoryName == catagory})!
    }
    
    var selectMenuItem:Menu?
    
    func selectMenuItem(_ menu:Menu) {
        selectMenuItem = menu
        menuOptionState = MenuOptionState(menu: menu)
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
    
    func updateSelectOption(_ code:String, _ group:String) {
        menuOptionState?.selectOptions.updateValue(code, forKey: group)
    }
    
    func inOptionlist(_ code:String, _ group:String) -> Bool {
        return menuOptionState?.selectOptions.contains(where: {$0 == group && $1 == code}) ?? false
    }
    
}


struct MenuOptionState {
    private let menu:Menu
    
    var selectOptions:[String:String] = [:]
    
    init(menu: Menu) {
        self.menu = menu
        getInitOptions()
    }
    
    var optionList:[OptionGroup] {
        menu.optionGroupVoList ?? []
    }
    
    var images:[String] {
        [menu.homeImage,menu.homeImageHttp]
    }
    
    var mainTitle:String {
        menu.mainTitle
    }
    
    var subTitle:String {
        guard let titles = menu.subtitle else
        { return "" }
        return titles[0]
    }
    
    
    
    
    
    private mutating func getInitOptions(){
        guard let options = menu.optionGroupVoList else {
            return
        }
        
        for option in options {
            
            let selectCode = option.optionVoList.first(where: {$0.standard == 1})?.optionCode ?? ""
            
            selectOptions.updateValue(selectCode, forKey: option.groupCode)
       
        }

        
    }
    
    
    
}
