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


struct CartButton: View {
    @Environment(\.cargoStore) var cargoStore
    @FetchRequest(fetchRequest: CargoItem.CargoRequest)
    private var shoppingCart: FetchedResults<CargoItem>
    
    let icon:String
    let text:String
    @State var bgColor:Color
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
