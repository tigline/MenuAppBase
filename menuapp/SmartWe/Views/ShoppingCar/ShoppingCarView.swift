//
//  ShoppingCarView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/16.
//

import SwiftUI

struct ShoppingCarView: View {
    
    @Environment(\.store.state.appTheme) var theme
    @Environment(\.store.cargoStore) var cargoStore
    
    var body: some View {
        
        if cargoStore.shoppingCart.isEmpty {
            VStack {
                ContentUnavailableView("ご注文くださいい", systemImage: "exclamationmark.circle")
            }
            .background(.white)
            
                
        } else {
            
            VStack {
                ScrollView(.vertical) {
                    LazyVStack(content: {
                        ForEach(cargoStore.shoppingCart) { item in
                            CargoCellView(item: item, addOrMinus: { action, item in
                                switch action {
                                case .add:
                                    cargoStore.addGood(item)
                                case .minus:
                                    cargoStore.removeGood(item)
                                }
                            })
                        }
                    })
                }
                
                HStack {
                    Color.clear
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        goodsCountView
                        priceCountView
                        totleCountView
                        orderButton
                    }
                    
                }
                .padding(.trailing, 50)
                .background(theme.themeColor.mainBackground)
                .frame(height: 220)
            }
            .padding(20)
            .background(theme.themeColor.contentBg)
        }
    }
    
    
    
    @ViewBuilder
    var orderButton: some View {
        HStack {
            Spacer()
            Button("発信") {
                cargoStore.shoppingCart.removeAll()
            }
            .foregroundStyle(.white)
            .frame(width: 200, height: 50)
            .background(.orange)
            .clipCornerRadius(10)
        }
        
    }
    
    @ViewBuilder
    var goodsCountView: some View {
        HStack {
            Text("数量")
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text(cargoStore.goodsCount)
                .frame(alignment: .trailing)
        }
    }
    
    @ViewBuilder
    var priceCountView: some View {
        HStack {
            Text("小计")
                .frame(alignment: .leading)
            Spacer()
            Text(cargoStore.subTotle)
                .frame(alignment: .trailing)
        }
    }
    
    @ViewBuilder
    var totleCountView: some View {
        HStack {
            Text("合计")
                .font(.title)
                .frame(alignment: .leading)
            Spacer()
            Text(cargoStore.allTotle)
                .frame(alignment: .trailing)
        }
    }
}

#Preview {
    ShoppingCarView()
}
