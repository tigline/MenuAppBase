//
//  TableView.Model.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/21.
//

import Foundation
import SwiftUI

extension TabelView {
    
    class Model {
        
        let tableInfo:TableInfo
        
        init(tableInfo: TableInfo) {
            self.tableInfo = tableInfo
        }
        
        var state:TableState {
            TableState(rawValue: tableInfo.state) ?? .empty
        }
        
        var seatCount:LocalizedStringKey {
            LocalizedStringKey("\(tableInfo.seatAttributeVo.howPeople)seat_count_text")
        }
        
        var floor:LocalizedStringKey {
            LocalizedStringKey("\(tableInfo.seatAttributeVo.floor)floor_text")
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
        
        var subTableInfo1: (String) -> String = { parameter in
            return "SubTableInfo is \(parameter)"
        }
        
        var subTablelOrderkeys:[String] {
            tableInfo.orderKeys ?? []
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
