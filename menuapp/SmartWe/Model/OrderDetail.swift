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

struct CustOrderDetails: Codable, Identifiable {
    var id:Int {self.lineId}
    let goodsNum: String?
    let image: String?
    let lineId: Int
    let mainTitle: String?
    let optionVoListMsgList: [[String]]?
    let optionVoListMsgMap: [String: [String]]?
    let orderTime: String?
    let price: Int
    let qty: Int
}
