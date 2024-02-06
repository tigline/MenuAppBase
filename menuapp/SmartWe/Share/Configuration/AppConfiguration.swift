//
//  AppConfiguration.swift
//  SmartWe
//
//  Created by Aaron on 2024/2/6.
//

import Foundation

#if DEBUG
let serverURL = URL(string: "https://waiter-sit.smartwe.co.jp/")!
#else
let serverURL = URL(string: "https://waiter.smartwe.co.jp/")!
#endif
