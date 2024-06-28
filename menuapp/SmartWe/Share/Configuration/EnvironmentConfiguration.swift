//
//  AppConfiguration.swift
//  SmartWe
//
//  Created by Aaron on 2024/2/6.
//

import Foundation

#if DEBUG
let serverURL = URL(string: "https://sit-api.smartwe.jp")!
#else
let serverURL = URL(string: "https://api.smartwe.jp")!
#endif

let testMachineCode = "CdAGJxpvT5ypdpnzsv"
