//
//  SmartWeService.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/06.
//

import Foundation

protocol SmartWeService {

    func activeDevice(machineCode:String) async throws -> Response<MachineInfo>

//    func categroryList(shopCode:String,machineCode:String) async throws -> Response

    func menuItemList(shopCode:String,language:String) async throws -> Response<ShopMenuInfo>
    
    func sendOrder(_ body:Data) async throws -> Response<Bool>
    
    func callWaiter(_ machineCode: String, _ tableNo:String) async throws -> Response<Bool>
    
    func bindTableNo(_ shopCode:String, _ tableNo:String) async throws -> Response<TableInfo>
    
    func checkOrder(_ shopCode:String, _ orderKey:String) async throws -> Response<String>
    
    func orderDetail(_ machineCode:String) async throws -> Response<OrderDetail>
}




struct MachineInfo: Codable {
    let linePayChannelMap: [String: Bool]?
    let languages: [String]
    let machineType: String
    let tableNo: String?
    let shopCode: String
    let machineCode: String
    let logoImage: String
    let homeImages: [String]?
    let lineup: Bool?
    let actuarial: Bool?
    let reimburse: Bool?
}

struct TableInfo: Codable {
    let tableNo:String
    var orderKeyList:[SubTable]?
    
    
    struct SubTable: Codable {
        let orderKey:String
        let state:Int
        let subTableNo:String
    }
}
