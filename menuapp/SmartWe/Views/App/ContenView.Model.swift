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
        let configuration:AppConfiguration
        
        init(configuration: AppConfiguration) {
            self.configuration = configuration
        }
        
//        init(completion: @escaping (Model) -> Void) {
//            completion(self)
//        }
        
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
        @MainActor
        private func performNetworkRequest(_ shopCode:String,
                                           _ orderKey:String) async throws {
            try await withCheckedThrowingContinuation { continuation in
                    let request = APIRequest(resource: OrderCheckResource(shopCode: shopCode,
                                                                          orderKey: orderKey))
                    Task {
                        do {
                            let result = try await request.execute()
                            if result.code == 200 {
                                if result.data {
                                    
                                } else {
                                    
                                    let table = configuration.tableNo
                                    configuration.tableNo = nil
                                    configuration.orderKey = nil
                                    
                                    try? await load(shopCode: shopCode, tableNo: table)
                                    
                                }
                            }
                            continuation.resume()
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                    
                }
        }
        
        @MainActor
        func load(shopCode:String, tableNo:String?) async throws {
            
            let resource = SelectTableResource(shopCode: shopCode)
            let request = APIRequest(resource: resource)
            
            do {
                let result = try await request.execute()
                if result.code == 200 {
                    
                    let tableList = result.data
                    
                    guard let tableInfo = tableNo?.split(separator: "ー") else {return}
                    
                    guard tableInfo.count > 1 else {return}
                    
                    guard let seat = Int(tableInfo[1]) else { return}
                    
                    guard let newTableInfo = tableList.first(where: {$0.seatNumber == tableInfo[0]}) else { return }
                        
                    guard let orderKey = newTableInfo.orderKeys?[seat-1], orderKey != "" else {return}
                    
                    configuration.tableNo = tableNo
                    configuration.orderKey = orderKey

                } else {
                    throw CustomError.createCustomError()
                }
                
            } catch {
                throw error
            }
            
        }
    }
    
}
