//
//  MenuItem.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/06.
//

import Foundation

struct ShopMenuInfo: Codable {
    let shopCode: String
    let machineCode: String?
    let languages: [Language]
    let shopName: String
    let ntaNo: String
    let language: String
    let shopAddress: String
    let shopTelephone: String
    let businessTime: String?
    let seatNumber: Int?
    let categoryVoList: [MenuCategory]
    let linePayChannelMap: [String: Bool]? // 根据实际情况可能需要调整类型
}

struct Language: Codable {
    let val: String
    let name: String
}

struct MenuCategory: Codable {
    let categoryCode: String
    let categoryName: String
    let showType: String
    let printReceipt: Int
    let menuVoList: [Menu]
}

struct OptionGroup: Codable {
    let groupCode: Int
    let groupName: String
    let multipleState: Int
    let optionVoList: [OptionVo]
    let printText: String
    let remark: String
    let smallest: Int
}

struct OptionVo: Codable {
    let bounds: Int
    let boundsPrice: Double
    let buttonColorValue: Int
    let currentPrice: Double
    let group: Int
    let groupName: String
    let homeImage: String
    let homeImageHttp: String
    let mainTitle: String
    let optionCode: String
    let price: Double
    let printText: String
    let standard: Int
    let subTitle: String
}


struct Menu: Codable {
    let menuCode: String
    let barCode: String
    let type: Int
    let categoryCode: String
    let mainTitle: String
    let subtitle: [String]?
    let printText: String
    let price: Double
    let currentPrice: Double
    let homeImage: String
    let homeImageHttp: String
    let images: [String]?
    let qtyBounds: Int
    let boundsPrice: Double?
    let timeBoundsStart: [Int]
    let timeBoundsEnd: [Int]
    let optionGroupVoList: [OptionGroup]?
}


