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
    
}

extension SmartWeService {
    func activeDevice(machineCode:String) async throws -> Response<MachineInfo> {
        return try await activeDevice(machineCode: machineCode)
    }
    
//    func categroryList(shopCode:String,machineCode:String) async throws -> Response {
//        try await categroryList(shopCode: shopCode, machineCode: machineCode)
//    }
    
    func menuItemList(shopCode:String,language:String) async throws -> Response<ShopMenuInfo> {
        return try await menuItemList(shopCode: shopCode, language: language)
    }
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

