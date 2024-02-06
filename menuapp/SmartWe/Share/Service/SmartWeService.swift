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
//
//    func menuItemList(shopCode:String,machineCode:String,categoryCode:String) async throws -> Response
    
}

extension SmartWeService {
    func activeDevice(machineCode:String) async throws -> Response<MachineInfo> {
        try await activeDevice(machineCode: machineCode)
    }
    
//    func categroryList(shopCode:String,machineCode:String) async throws -> Response {
//        try await categroryList(shopCode: shopCode, machineCode: machineCode)
//    }
    
//    func menuItemList(shopCode:String,machineCode:String,categoryCode:String) async throws -> Response {
//        try await menuItemList(shopCode: shopCode, machineCode: machineCode, categoryCode: categoryCode)
//    }
}



struct MachineInfo: Codable {
    let actuarial: Bool
    let homeImages: [String]
    let languages: [String]
    let linePayChannelMap: [String: Bool]
    let lineup: Bool
    let logoImage: String
    let machineCode: String
    let machineType: String
    let reimburse: Bool
    let shopCode: String
    let tableNo: String
}
