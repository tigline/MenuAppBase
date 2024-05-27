//
//  TableView.Model.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/21.
//

import Foundation
import SwiftUI

extension TabelView {
    @Observable
    class Model {
        
        let appData:AppConfiguration
        
        let coreDataStack = CoreDataStack.shared
        
        var tableInfo:TableInfo
        
        init(tableInfo: TableInfo, appData:AppConfiguration) {
            self.tableInfo = tableInfo
            self.appData = appData
        }
        
        var state:TableState {
            TableState(rawValue: tableInfo.state) ?? .empty
        }
        
        var howPeople:String {
            tableInfo.seatAttributeVo?.howPeople ?? ""
        }
        
        var floorNumber:String {
            tableInfo.seatAttributeVo?.floor ?? ""
        }
        
        var seatCount:LocalizedStringKey {
            LocalizedStringKey("\(howPeople)seat_count_text")
        }
        
        var floor:LocalizedStringKey {
            LocalizedStringKey("\(floorNumber)floor_text")
        }
        
        
        func subTableInfo(_ index:Int) -> LocalizedStringKey {
            
            if subTablelOrderkeys.count < index {return "Not a Seat"}
            
            if subTablelOrderkeys[index].isEmpty {
                return "\(index + 1) table_not_opened"
            } else {
                return "\(index + 1) table_opened"
            }
            
        }
        
        func seatButtonColor(_ index:Int) -> Color {
            
            if subTablelOrderkeys.count < index {return .gray}
            
            if subTablelOrderkeys[index].isEmpty {
                return .gray
            } else {
                return .red
            }
            
        }
        
        func seatButtonOpened(_ index:Int) -> Bool {
            
            if subTablelOrderkeys.count < index {return false}
            
            if subTablelOrderkeys[index].isEmpty {
                return false
            } else {
                return true
            }
            
        }
        
        var subTableInfo1: (String) -> String = { parameter in
            return "SubTableInfo is \(parameter)"
        }
        
        var subTablelOrderkeys:[String]
        {
            tableInfo.orderKeys ?? []
        }
        
        
        @MainActor
        func openSeat(shopCode:String, seatNumber:String, subSeat:Int) async throws {
            let tableNo = tableInfo.seatNumber + "ー" + "\(subSeat+1)"
            if subTablelOrderkeys[subSeat] == "" {
                let resource = OpenSeatResource(shopCode: shopCode, seatNumber: seatNumber, subSeat: subSeat+1)
                let request = APIRequest(resource: resource)
                
                do {
                    let result = try await request.execute()
                    if result.code == 200 {
                        tableInfo.state = result.data.state
                        
                        if let newKey = result.data.orderKey {
                            
                            appData.tableNo = tableNo
                            appData.orderKey = newKey
                            await updateTableNumber(tableNo)
                        }
                        
                    } else {
                        throw CustomError.createCustomError()
                    }
                    
                } catch {
                    throw error
                }
            } else {
                appData.tableNo = tableNo
                appData.orderKey = subTablelOrderkeys[subSeat]
                await updateTableNumber(tableNo)
            }
        }
        
        func updateTableNumber(_ number:String? = "19") async {
            try? await coreDataStack.updateCargoKeyValue(key: "tableNo", value: number)
        }
        
        enum TableState:Int {
            case empty
            case ready
            case used
            case full
            
            var localizedString: LocalizedStringKey {
                switch self {
                
                case .empty:
                    return "seat_state_empty"
                case .ready:
                    return "seat_state_standby"
                case .used:
                    return "seat_state_used"
                case .full:
                    return "seat_state_full"
                }
            }
            
            var bgColor:Color {
                switch self {
                    
                case .empty:
                    return .init(hex: "#e9e9e9")
                case .ready:
                    return .init(hex: "#3e89ff")
                case .used:
                    return .init(hex: "#5D3A1A") //#c52100
                case .full:
                    return .init(hex: "#00b65c")
                }
            }
            
            var textColor:Color {
                switch self {
                    
                case .empty:
                    return .init(hex: "#000000")
                case .ready:
                    return .init(hex: "#FFFFFF")
                case .used:
                    return .init(hex: "#FFFFFF")
                case .full:
                    return .init(hex: "#FFFFFF")
                }
            }
            
        }
        
        
        
    }
    
}


struct OpenSeatResource:APIResource {
    typealias ModelType = Response<TableInfo>
    
    var path: String = "/pad/web/ipad/table/open"
    
    var method: HttpMethod = .POST
    
    var body: Data? {
        ["shopCode":shopCode,
         "seatNumber":seatNumber,
         "subSeat":subSeat
        ].toJSONData() ?? Data()
    }
    
    let shopCode:String
    let seatNumber:String
    let subSeat:Int
    
    
}
