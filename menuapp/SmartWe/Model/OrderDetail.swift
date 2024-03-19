//
//  OrderDetail.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/11.
//

import Foundation

struct OrderDetail: Codable {
    let categoryVos: [CategoryVo]?
    let currentTimeMillis: Int?
    let custOrderDetailsList: [CustOrderDetails]?
    let orderKey: String?
    let qty: Int?
    let serialNumber: String?
    let takeOut: String?
    let totalPrice: Int?
}

struct CategoryVo: Codable {
    let categoryName: String
    let custOrderDetailsList: [CustOrderDetails]?
}

struct CustOrderDetails: Identifiable, Codable {
    let id = UUID()
    let goodsNum: String?
    let image: String?
    let lineId: Int?
    let mainTitle: String?
    let optionVoListMsgList: [[String]]?
    let optionVoListMsgMap: [String: [String]]?
    let orderTime: String?
    let price: Int
    let qty: Int
    
    enum CodingKeys: String, CodingKey {
            case goodsNum, image, lineId, mainTitle, optionVoListMsgList, optionVoListMsgMap, orderTime, price, qty
        }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        goodsNum = try container.decodeIfPresent(String.self, forKey: .goodsNum)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        lineId = try container.decodeIfPresent(Int.self, forKey: .lineId)
        mainTitle = try container.decodeIfPresent(String.self, forKey: .mainTitle)
        optionVoListMsgList = try container.decodeIfPresent([[String]].self, forKey: .optionVoListMsgList)
        optionVoListMsgMap = try container.decodeIfPresent([String: [String]].self, forKey: .optionVoListMsgMap)
        orderTime = try container.decodeIfPresent(String.self, forKey: .orderTime)
        price = try container.decode(Int.self, forKey: .price)
        qty = try container.decode(Int.self, forKey: .qty)
    }
}
