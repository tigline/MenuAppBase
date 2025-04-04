//
//  OrderButton.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/08.
//

import SwiftUI

struct OrderButton: View {
    //@Environment(\.store.state.appTheme) var theme
//    @StateObject private var configuration = AppConfiguration.share
//    private var appTheme:AppTheme {
//        configuration.colorScheme
//    }
    @EnvironmentObject private var appConfig:AppConfiguration
    
    let icon:String
    let text:LocalizedStringKey
    let bgColor:Color
    let textColor:Color
    let onTap:()->Void
    
    var body: some View {
        Button(action: {
            onTap()
        }, label: {
            HStack(alignment: .center) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32,height: 32)
                
                Text(text)
                    .font(appConfig.appLanguage.regularFont(16))
                    .foregroundStyle(textColor)
                
            }
            .padding(8)
            .background(bgColor)
            .cornerRadius(10)
        })
        .buttonStyle(.plain)
        .frame(height: 44)
        
    }
}

struct ExpandButton: View {
    @EnvironmentObject private var appConfig:AppConfiguration
    let icon:String
    let text:LocalizedStringKey
    let bgColor:Color
    let textColor:Color
    let onTap:()->Void
    
    var body: some View {
        Button(action: {
            onTap()
        }, label: {
            HStack {
                Label(text, image: icon)
                    .font(appConfig.appLanguage.regularFont(16))
                    .foregroundColor(textColor)
                Spacer()
            }
            .padding(8)
            .background(bgColor)
            .cornerRadius(10)
        })
        .buttonStyle(.plain)
        .frame(height: 44)
        
    }
}


struct CartButton: View {
    
    @EnvironmentObject private var appConfig:AppConfiguration
    @FetchRequest(fetchRequest: CargoItem.CargoRequest)
    private var shoppingCart: FetchedResults<CargoItem>
    
    let icon:String
    let text:LocalizedStringKey
    let bgColor:Color
    let textColor:Color
    let onTap:()->Void
    
    @State var hightLight:Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                onTap()
            }, label: {
                HStack {
                    Label(text, image: icon)
                        .font(appConfig.appLanguage.regularFont(16))
                        .foregroundColor(textColor)
                }
                .padding(8)
                .background(bgColor)
                .cornerRadius(10)
            })
            .buttonStyle(.plain)
            .frame(height: 44)
            
            if shoppingCart.count > 0 {
                Text(goodsCount)
                    .font(.caption2).bold()
                    .foregroundColor(.white)
                    .frame(width: 18, height: 18)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: 10, y: -10)
            }
            
            
            
        }
        
    }
    
    var goodsCount:String {
        let count = shoppingCart.reduce(into: 0) { count, item in
            count += item.quantity
        }
        return "\(count)"
    }
}
