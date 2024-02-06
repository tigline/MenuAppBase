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
        try await apisClient.post(path: , body: )
    }
}
