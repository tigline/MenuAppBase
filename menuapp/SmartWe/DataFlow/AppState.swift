//
//  AppState.swift
//

import Foundation

struct AppState {
    var destinations = [Destination]()
    var favoriteMovieIDs = Set<Int>()
    var favoritePersonIDs = Set<Int>()
    var tabDestination: TabDestination = .movie
    var sideSelection: String = ""
    var machineCode: String = "X3V9YPJABVZGAELIZ9"
    var checkLanguage: String = "JP"
    var machineInfo: MachineInfo = .createDefault()
    var shopMenuInfo: ShopMenuInfo?
    var appTheme: Assets = .orange
}

struct ShopMenuState {
    
    var categorys:[String] = []
    var menuInfos:[MenuCategory] = []
    
    mutating func updateMenuInfos(_ shopMenuInfo: ShopMenuInfo) {
      menuInfos = shopMenuInfo.categoryVoList
    }
    
}

struct MenuState: Hashable, Identifiable {
    var id: Int = 0
    var categoryName:String = ""
    var itemList:[Menu] = []
}

struct ItemState {
    
}


struct ShopInfo {
    let name:String
    let address:String
    let invoice:String 
    let telNumber:String
    let deviceCode:String
    let machineCode:String
}

extension ShopInfo {
    
}

extension MachineInfo {
    static func createDefault() -> MachineInfo {
        return MachineInfo(
            linePayChannelMap: nil,
            languages: ["EN"],
            machineType: "CUSTER_PAD",
            tableNo: nil,
            shopCode: "DEFAULT_SHOP",
            machineCode: "DEFAULT_MACHINE",
            logoImage: "http://example.com/default_logo.bmp",
            homeImages: nil,
            lineup: nil,
            actuarial: nil,
            reimburse: nil
        )
    }
    
}

