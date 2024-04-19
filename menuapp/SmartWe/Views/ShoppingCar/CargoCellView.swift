//
//  CargoCellView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/16.
//

import SwiftUI
import NukeUI

struct CargoCellView: View {
    @StateObject private var configuration = AppConfiguration.share
    var themeColor:ThemeColors {
        configuration.colorScheme.themeColor
    }
    enum CargoAction {
        case add
        case minus
        case remove
    }
    
    let item:CargoItem
    let addOrMinus:(_ action:CargoAction, _ item:CargoItem)->Void
    
    @State private var quantity:Int = 999
    
    var tableNo:LocalizedStringKey {
        LocalizedStringKey(item.tableNo ?? "select_a_table")
    }
    
    var body: some View {
        VStack {
            
            
            HStack {
                
                MenuItemPoster(imagePath: URL(string: item.imageUrl ?? ""),
                               size: CGSize(width: 90, height: 60))

                Text(item.title ?? "")
                    .padding(.horizontal)
                    .font(CustomFonts.carGoMenuFont)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(themeColor.cargoTextColor)
                
                Text("¥" + "\(Int(item.price))")
                    .padding(.horizontal)
                    .font(CustomFonts.carGoMenuFont)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(themeColor.cargoTextColor)
                Spacer()
                Text(tableNo)
                    .padding(.horizontal)
                    .font(CustomFonts.carGoMenuFont)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(themeColor.cargoTextColor)
                
                HStack {
                    
                    Button {
                        addOrMinus(.minus, item)
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 10, height: 10)
                            .foregroundStyle(Color.init(hex: "#01000D"))
                    }
                    .frame(width: 30, height: 30)
                    .buttonStyle(BorderlessButtonStyle())
                    .background(themeColor.quantityBtBg)
                    .cornerRadius(8)
                    
                    Text("\(item.quantity)")
                        .font(CustomFonts.carGoMenuFont)
                        .foregroundStyle(themeColor.cargoTextColor)
                        .frame(width: 30)
                    
                    Button {
                        addOrMinus(.add, item)
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 10, height: 10)
                            .foregroundStyle(Color.init(hex: "#01000D"))
                    }
                    .frame(width: 30, height: 30)
                    .buttonStyle(BorderlessButtonStyle())
                    .background(themeColor.quantityBtBg)
                    .cornerRadius(8)
                    
                }.padding(.vertical)
                
                Spacer()
                
                Button {
                    addOrMinus(.remove, item)
                } label: {
                    Image("delete_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                .padding(.leading, 40)

                
            }
            .padding(.vertical, 10)
            .padding(.leading, 45)
            .padding(.trailing, 22)
            .background(.clear)
            
            Rectangle()
                    .padding(.horizontal, 21)
                    .frame(height: 0.5)
                    .foregroundColor(themeColor.cargoLine)
                    
            
        }
        
    }
}

//#Preview {
//    List{
//        CargoCellView()
//
//    }
//    
//}

