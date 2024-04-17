//
//  ContenView.Model;.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/27.
//

import Foundation

extension ContentView {
    
    @Observable
    class Model {
        
        private var isChecking:Bool = false
        
        
        func startCheck(_ shopCode:String? = nil, 
                        _ orderKey:String? = nil) async {
            print("--startCheck--")
            guard let shop = shopCode else {
                return
            }
            guard let order = orderKey else {
                return
            }
            
            if isChecking == true {
                stopRepeatingTask()
                try? await Task.sleep(nanoseconds: 10_000_000_000)
            }
            isChecking = true
            await checkTask(shop, order)
        }
        
        func stopRepeatingTask() {
            print("--stopRepeatingTask--")
            isChecking = false
        }
        
        
        private func checkTask(_ shopCode:String,
                       _ orderKey:String) async {
            print("--checkTask--")
            
            try? await performNetworkRequest(shopCode, orderKey)
            if isChecking {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                await checkTask(shopCode, orderKey)
            }
            
        }
        
        private func performNetworkRequest(_ shopCode:String,
                                           _ orderKey:String) async throws {
            try await withCheckedThrowingContinuation { continuation in
                    let request = APIRequest(resource: OrderCheckResource(shopCode: shopCode,
                                                                                          machineCode: orderKey))
                    Task {
                        do {
                            let result = try await request.execute()
                            if result.code == 200 {
                                if result.data {
                                    
                                } else {
                                    DispatchQueue.main.async {
                                        AppConfiguration.share.tableNo = nil
                                        AppConfiguration.share.orderKey = nil
                                    }
                                }
                            }
                            continuation.resume()
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                    
                }
        }
    }
    
}
