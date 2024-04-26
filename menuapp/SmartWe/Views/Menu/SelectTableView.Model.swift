//
//  SelectTableView.Model.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/21.
//

import Foundation

extension SelectTableView {
    @Observable
    class Model {
        
        var tableList:[TableInfo]?
        
        @MainActor
        func load(shopCode:String) async throws {
            
            let resource = SelectTableResource(shopCode: shopCode)
            let request = APIRequest(resource: resource)
            
            do {
                let result = try await request.execute()
                if result.code == 200 {
                    tableList = result.data
                } else {
                    throw CustomError.createCustomError()
                }
                
            } catch {
                throw error
            }
            
        }
        
    }

}



extension Error {
    static func createCustomError() -> Error {
        let errorDomain = "com.smartwe.nodata"
        let errorCode = 999
        let userInfo = [NSLocalizedDescriptionKey: "No order for this table"]

        return NSError(domain: errorDomain, code: errorCode, userInfo: userInfo)
    }
}

enum CustomError: Error {
    case noData
    
    static func createCustomError(domain:String, code:Int, info:String) -> Error {
        let errorDomain = domain
        let errorCode = code
        let userInfo = [NSLocalizedDescriptionKey: info]
        return NSError(domain: errorDomain, code: errorCode, userInfo: userInfo)
    }
}



struct SelectTableResource:APIResource {
    typealias ModelType = Response<[TableInfo]>
    
    var path: String = "/pad/web/ipad/list"
    
    var method: HttpMethod = .GET
    
    var parameter:[String:String]? {
        ["shop_code":shopCode]
    }
    
    let shopCode:String
}


//struct TableInfo: Codable {
//    let tableNo:String
//    var orderKeyList:[SubTable]?
//    
//    
//    struct SubTable: Codable {
//        let orderKey:String
//        let state:Int
//        let subTableNo:String
//    }
//}

struct TableInfo:Identifiable, Codable, Equatable, Hashable {
    
    
    var id:String {seatNumber}
    
    let currentTime:String?
    let orderKey:String?
    let orderQty:Int?
    var orderKeys:[String]?
    let seatAttributeVo:SeatAttributeVo?
    let seatNumber:String
    let shopCode:String
    var state:Int
    
    
    struct SeatAttributeVo: Codable, Equatable, Hashable {
        let floor:String
        let howPeople:String
    }
    
    
}
//{
//    "shopCode":"UGE4RRQR",
//    "seatNumber":"お席：００６ー１",
//    "subSeat":1,
//    "orderKey":null,
//    "orderKeyQty":null,
//    "orderKeys":["https://waiter-sit.smartwe.co.jp/index?p=1qELv7ixzKNE8zXT2jQLW"],
//    "state":1,
//    "seatAttributeVo":null,
//    "currentTime":"2024-04-25 18:03:03"
//}
