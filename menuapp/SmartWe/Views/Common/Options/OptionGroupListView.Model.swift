//
//  OptionGroupListView.Model.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/19.
//

import Foundation

extension OptionGroupListView {
    
    @Observable
    class Model {
        private let menu:Menu
        private let coreDataStack = CoreDataStack.shared
        
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
        
        var totlePrice:Int {
            let price = selectOptions.reduce(0) { count, option in
                count + option.price
            }
            
            return Int(price) + Int(menu.currentPrice)
        }
        
        var subTitle:String {
            guard let titles = menu.subtitle else
            { return "" }
            return titles[0]
        }
        
        var optionGoodInfo:(Menu, Int, [String]) {
            let options = selectOptions.map({$0.optionCode})
            return (menu,totlePrice,options)
        }
        
        func updateOption(_ code:String, _ group:String, _ price:Double) {
            if let index = selectOptions.firstIndex(where: { $0.groupCode == group }) {
                selectOptions[index].optionCode = code
                selectOptions[index].price = price
            }
        }
        
        private func getInitOptions(){
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
        
        func inOptionlist(_ code:String, _ group:String) -> Bool {
            return selectOptions.contains(where: {$0.groupCode == group && $0.optionCode == code})
        }
        
        func addGood(price:Int = 0, table:String ,options:[String] = []) {
            
            
            let goodItem = GoodItem(id: 0,
                                    menuCode: menu.menuCode,
                                    image: menu.homeImage,
                                    title: menu.mainTitle,
                                    price: totlePrice,
                                    optionCodes: selectOptions.map({$0.optionCode}), 
                                    table: table
                                   )
            
            coreDataStack.updateCargoItem(menuCode: goodItem.menuCode, item: goodItem)
        }
        
    }
}
