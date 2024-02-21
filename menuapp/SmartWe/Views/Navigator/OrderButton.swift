//
//  OrderButton.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/08.
//

import SwiftUI

struct OrderButton: View {
    //@Environment(\.store.state.appTheme) var theme
    
    let icon:String
    let text:String
    let bgColor:Color
    let textColor:Color
    let onTap:()->Void
    
    var body: some View {
        Button(action: {
            onTap()
        }, label: {
            HStack {
                Label(text, image: icon)
                    .foregroundColor(textColor)
            }
            .padding(8)
            .background(bgColor)
            .cornerRadius(10)
        })
        .buttonStyle(.plain)
        
    }
}
//HStack {
//    Label(menu.categoryName, systemImage: "hand.thumbsup.fill")
//        .foregroundColor(store.state.sideSelection == menu.categoryName ? .white : .init(hex: "#828282"))
//    Spacer()
//}
//.padding(EdgeInsets(top: 15, leading: 30, bottom: 10, trailing: 0))
//.background(store.state.sideSelection == menu.categoryName ? theme.themeColor.buttonColor : Color.clear)
//#Preview {
//    OrderButton()
//}
struct CartButton: View {
    @Environment(\.cargoStore) var cargoStore
    
    let icon:String
    let text:String
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
                        .foregroundColor(textColor)
                }
                .padding(8)
                .background(bgColor)
                .cornerRadius(10)
            })
            .buttonStyle(.plain)
            
            if cargoStore.shoppingCart.count > 0 {
                Text("\(cargoStore.goodsCount)")
                    .font(.caption2).bold()
                    .foregroundColor(.white)
                    .frame(width: 18, height: 18)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: 10, y: -10)
            }
            
            
            
        }
        
    }
}
