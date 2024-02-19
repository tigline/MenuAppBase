//
//  MenuStore.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/14.
//

import Observation
import UIKit

@Observable
class MenuStore {
    var cartIconGlobalFrame: CGRect = .zero
    
    let appService:AppService
    
    var shopMenuInfo:ShopMenuInfo?
    
    var menuOptionState:MenuOptionState?
    
    var menuList:[MenuCategory] {
        shopMenuInfo?.categoryVoList ?? []
    }
    
    var catagorys:[String] {
        var list = menuList.map({$0.categoryName})
        list.append("shoppingCar")
        return list
    }
    
    var selectBarIndex:Int = 0 {
        didSet {
            
        }
    }
    
    var catagory:String {
        if catagorys.count > 0 {
            return catagorys[selectBarIndex]
        }
        return ""
    }
    
    func updateTab(_ tap:String) {
        if let index = catagorys.firstIndex(where: {$0 == tap}) {
            selectBarIndex = index
        }
    }
    
//    var curMenuInfo:MenuCategory {
//        return menuList.first(where: {$0.categoryName == catagory})!
//    }
    
    //var selectMenuItem:Menu?
    
    func selectMenuItem(_ menu:Menu) {
        //selectMenuItem = menu
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
        menuOptionState?.updateOption(code, group)
    }
    
    func inOptionlist(_ code:String, _ group:String) -> Bool {
        return menuOptionState?.selectOptions.contains(where: {$0.groupCode == group && $0.optionCode == code}) ?? false
    }
    
}




struct MenuOptionState {
    private let menu:Menu
    
    struct SelectOption {
        let menuCode:String
        let groupCode:String
        var optionCode:String
        var price:Double
        
        mutating func updateOption(_ option:String, price:Double) {
            self.optionCode = option
            self.price = price
        }
    }
    
    var selectOptions:[SelectOption] = []
    
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
    
    var totlePrice:Double {
        selectOptions.reduce(0) { count, option in
            count + option.price
        }
    }
    
    var subTitle:String {
        guard let titles = menu.subtitle else
        { return "" }
        return titles[0]
    }
    
    var optionGoodInfo:(Menu, Double, [String]) {
        let options = selectOptions.map({$0.optionCode})
        return (menu,totlePrice,options)
    }
    
    mutating func updateOption(_ code:String, _ group:String) {
        if let index = selectOptions.firstIndex(where: { $0.groupCode == group }) {
            selectOptions[index].optionCode = code
        }
    }
    
    private mutating func getInitOptions(){
        guard let options = menu.optionGroupVoList else {
            return
        }
        
        for option in options {
            
            let optionVo = option.optionVoList.first(where: {$0.standard == 1})
            
            selectOptions.append(SelectOption(menuCode: menu.menuCode,
                                              groupCode: option.groupCode,
                                              optionCode: optionVo?.optionCode ?? "",
                                              price: optionVo?.currentPrice ?? 0))
       
        }

        
    }
    
    
    
}
