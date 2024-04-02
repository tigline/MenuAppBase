//
//  MachineInfo.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/21.
//

import Foundation
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
