//
//  AppService.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/06.
//

import Foundation


class AppService: SmartWeService {
    
    
    private let apisClient: APISClient

    init(apisClient: APISClient) {
        self.apisClient = apisClient
    }
    
    func activeDevice(machineCode: String) async throws -> Response<MachineInfo> {
        return try await apisClient.post(point: SmartWePostEndpoint.active(machineCode: machineCode))
    }
    
    func menuItemList(shopCode: String, language: String) async throws -> Response<ShopMenuInfo> {
        return try await apisClient.post(point: SmartWePostEndpoint.menu(shopCode: shopCode, language: language))
    }
    
    func sendOrder(_ body: Data) async throws -> Response<Bool> {
        return try await apisClient.post(point: SmartWePostEndpoint.order(body))
    }
}
