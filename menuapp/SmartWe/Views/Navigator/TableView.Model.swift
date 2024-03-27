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
        
        var seatCount:String {
            tableInfo.seatAttributeVo.howPeople + "人席"
        }
        
        var floor:String {
            tableInfo.seatAttributeVo.floor + "階"
        }
        
        
        func subTableInfo(_ index:Int) -> String {
            
            if subTablelOrderkeys.count < index {return "Not a Seat"}
            
            if subTablelOrderkeys[index].isEmpty {
                return "No." + "\(index + 1) " +  "未开席"
            } else {
                return "No." + "\(index + 1) " +  "已开席"
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
            [
                "alsmldjn",
                "",
                "ashjbfk",
                "",
            ]
        }
        
        
        
        enum TableState:Int {
            case empty
            case ready
            case used
            case full
            
            var localizedString: LocalizedStringKey {
                switch self {
                
                case .empty:
                    return "空席"
                case .ready:
                    return "待席"
                case .used:
                    return "使用中"
                case .full:
                    return "满席"
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
