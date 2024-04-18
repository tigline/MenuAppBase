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
    
    func menuItemList(shopCode: String, machineCode:String, language: String) async throws -> Response<ShopMenuInfo> {
        return try await APIRequest(resource: MenuResource(shopCode: shopCode, machineCode: machineCode, language: language)).execute()
    }
    
    func sendOrder(_ body: Data) async throws -> Response<Bool> {
        return try await apisClient.post(point: SmartWePostEndpoint.order(body))
    }
    
    func callWaiter(_ machineCode: String, _ tableNo:String) async throws -> Response<Bool> {
        return try await apisClient.get(point: SmartWeGetEndPoint.callWaiter(machineCode: machineCode, tableNo: tableNo))
    }
    
    func bindTableNo(_ shopCode:String, _ tableNo:String) async throws -> Response<TableInfo> {
        return try await apisClient.post(point: SmartWePostEndpoint.bindTable(shopCode: shopCode, tableNo: tableNo))
    }
    
    func checkOrder(_ shopCode: String, _ orderKey: String) async throws -> Response<String> {
        return try await apisClient.post(point: SmartWePostEndpoint.checkOrder(shopCode: shopCode, orderKey: orderKey))
    }
    
//    func orderDetail(_ machineCode: String) async throws -> Response<OrderDetail> {
//        return try await apisClient.post(point: SmartWePostEndpoint.orderDetail(machineCode: machineCode))
//    }
}
