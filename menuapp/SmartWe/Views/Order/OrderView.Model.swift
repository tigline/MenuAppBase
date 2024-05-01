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
            
            return categoryVos //.reversed().compactMap{$0}
        }
        
        func clearOrder() {
            orderInfo = nil
        }
        
        var totalQty:String {
            
            //"\(allOrderList.reduce(0){$0 + $1.qty})"
            formatMoney(allOrderList.reduce(0){$0 + $1.qty})
        }
        
        var totalPrice:String {
            //"\(allOrderList.reduce(0){$0 + $1.price})"
            formatMoney(allOrderList.reduce(0){$0 + $1.price})
        }
        
        var allTax:String {
            let price = allOrderList.reduce(0){$0 + $1.price}
            return "(¥\(formatMoney(price/11)))"
        }
        
        func formatMoney(_ value:Int)->String {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal // 设置数字格式为十进制，这将包括千位分隔符
            formatter.groupingSeparator = "," // 设置千位分隔符为逗号，可以根据地区需要调整
            formatter.groupingSize = 3 // 设置分组的大小为3位数字

            let formattedNumber = formatter.string(from: NSNumber(value: Int(value)))
            return formattedNumber ?? "\(Int(value))"
        }
        
        
        @MainActor func fetchOrders(shopCode:String, machineCode:String, table:String, lan:String) async throws {
            guard table != "" else { return }
            guard !isLoading else { return }
            defer {isLoading = false}
            isLoading = true
            
            let request = APIRequest(resource: OrderDetailResource(shopCode: shopCode,
                                                                   machineCode: machineCode,
                                                                   table: table, 
                                                                   language: lan))
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
        "orderKey":table,
        "language":language
        ].toJSONData() ?? Data()
    }
    
    let shopCode:String
    let machineCode:String
    let table:String
    let language:String
    
    
}
