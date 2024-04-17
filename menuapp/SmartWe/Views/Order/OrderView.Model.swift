//
//  OrderView.Model.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/18.
//

import Foundation

extension OrderView {
    
    @Observable
    class Model {
        
        private (set) var orderInfo:OrderDetail?
        private (set) var isLoading = false
        private (set) var errorMessage:String?
        
        var allOrderList: [CustOrderDetails] {
            
            guard let categoryVos = orderInfo?.custOrderDetailsList else {
                return []
            }
            
            return categoryVos.reversed().compactMap{$0}
        }
        
        var totalQty:String {
            
            "\(allOrderList.reduce(0){$0 + $1.qty})"
        }
        
        var totalPrice:String {
            "\(allOrderList.reduce(0){$0 + $1.price})"
        }
        
        var allTax:String {
            let price = allOrderList.reduce(0){$0 + $1.price}
            return "(\(price/11))"
        }
        
        
        @MainActor func fetchOrders(shopCode:String, machineCode:String, table:String) async throws {
            guard table != "" else { return }
            guard !isLoading else { return }
            defer {isLoading = false}
            isLoading = true
            
            let request = APIRequest(resource: OrderDetailResource(shopCode: shopCode,
                                                                   machineCode: machineCode,
                                                                   table: table))
            do {
                let result = try await request.execute()
                if result.code == 200 {
                    orderInfo = result.data
                } else {
                    throw createCustomError()
                }
            } catch {
                throw error
            }
        }
        
        func createCustomError() -> NSError {
            let errorDomain = "com.smartwe.nodata"
            let errorCode = 999
            let userInfo = [NSLocalizedDescriptionKey: "No order for this table"]

            return NSError(domain: errorDomain, code: errorCode, userInfo: userInfo)
        }
        
    }
    
}

struct OrderDetailResource:APIResource {
    typealias ModelType = Response<OrderDetail>
    
    var path: String = "/pad/web/ipad/order/detail"
    
    var method: HttpMethod = .POST
    
    var body: Data? {
        ["shopCode":shopCode,
        "orderKey":table
         //"orderKey":table
        ].toJSONData() ?? Data()
    }
    
    let shopCode:String
    let machineCode:String
    let table:String
    
    
}
