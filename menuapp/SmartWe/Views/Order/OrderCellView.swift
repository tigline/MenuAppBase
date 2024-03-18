//
//  OrderCellView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/18.
//

import SwiftUI

struct OrderCellView: View {
    @StateObject private var configuration = AppConfiguration.share
    
    var theme:AppTheme {
        configuration.colorScheme
    }
    
    let imageUrl:String
    let orderTime:String
    let title:String
    let optionInfo:[String: [String]]
    let quntity:Int
    let price:Int
    
    var optionContent:String {
        optionInfo.reduce(""){$0 + "\($1.key): \($1.value.joined(separator: ", "))、"}
    }
    
    var body: some View {
        
        VStack {
            HStack(spacing: 10) {
                MenuItemPoster(imagePath: URL(string: imageUrl),
                               size: CGSize(width: 90, height: 90))
                
                VStack(alignment: .leading) {
                    Text("注文时间: " + orderTime)
                        .padding(.horizontal)
                        .font(CustomFonts.cargoCountFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(theme.themeColor.cargoTextColor)
                    
                    Text(title)
                        .padding(.horizontal)
                        .font(CustomFonts.carGoMenuFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(theme.themeColor.cargoTextColor)
                    
                    Text(optionContent)
                        .padding(.horizontal)
                        .font(CustomFonts.cargoCountFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(theme.themeColor.cargoTextColor)
                    
                }
                
                VStack(alignment: .trailing){
                    Text("x " + "\(quntity)")
                        .padding(.horizontal)
                        .font(CustomFonts.cargoCountFont)
                    //.frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(theme.themeColor.cargoTextColor)
                    
                    Text("¥ " + "\(price)")
                        .padding(.horizontal)
                        .font(CustomFonts.carGoMenuFont)
                    //.frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(theme.themeColor.cargoTextColor)
                }
                
                Spacer()
                
            }
            .padding(.vertical, 10)
            .padding(.leading, 45)
            .padding(.trailing, 102)
            .background(.clear)
            
            Rectangle()
                    .padding(.horizontal, 21)
                    .frame(height: 0.5)
                    .foregroundColor(theme.themeColor.cargoLine)
        }
        
        
    }
}

#Preview {
    OrderCellView(imageUrl: "牛肉面",
                  orderTime: "15:33",
                  title: "牛肉面",
                  optionInfo: ["麺の量": ["普通"], "トッピング": ["辛味ニンニク"]],
                  quntity: 1,
                  price: 899)
}
