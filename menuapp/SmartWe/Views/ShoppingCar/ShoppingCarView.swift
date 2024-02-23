//
//  ShoppingCarView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/16.
//

import SwiftUI

struct ShoppingCarView: View {
    
    @Environment(\.store.state.appTheme) var theme
    @Environment(\.cargoStore) var cargoStore
    @StateObject private var configuration = AppConfiguration.share
    @FetchRequest(fetchRequest: CargoItem.CargoRequest)
    private var shoppingCart: FetchedResults<CargoItem>
    
    var goodsCount:String {
        let count = shoppingCart.reduce(into: 0) { count, item in
            count += item.quantity
        }
        return "\(count)"
    }
    
    var subTotle:String {
        allTotle
    }
    
    var allTotle:String {
        let all = shoppingCart.reduce(0) { count, item in
            count + item.price * Double(item.quantity)
        }
        return "\(all)"
    }
    
    
    var body: some View {
        
        if shoppingCart.isEmpty {
            VStack {
                ContentUnavailableView("ご注文くださいい", systemImage: "exclamationmark.circle")
            }
            .background(.white)
            
                
        } else {
            
            VStack(spacing: 0) {
                ScrollView(.vertical) {
                    LazyVStack(content: {
                        ForEach(shoppingCart) { item in
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
                .background(theme.themeColor.mainBackground)
                
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
                .padding(.trailing, 120)
                .background(theme.themeColor.mainBackground)
                .frame(height: 220)
            }
            .padding(20)
            .background(theme.themeColor.contentBg)
            .onAppear {
                
            }
//            .task(id: shoppingCart.count) {
//                cargoStore.updateShoppingCart(shoppingCart.map({$0}))
//            }
        }
            
    }
    
    
    
    @ViewBuilder
    var orderButton: some View {
        HStack {
            Spacer()
            Button("発信") {
                Task {
                    
                    await cargoStore.sendCarToOrder(shoppingCart: shoppingCart.map({$0}),
                                                    language: configuration.menuLaguage ?? "en",
                                              machineCode: configuration.machineCode ?? "")
                }
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
            Text(goodsCount)
                .frame(alignment: .trailing)
        }
    }
    
    @ViewBuilder
    var priceCountView: some View {
        HStack {
            Text("小计")
                .frame(alignment: .leading)
            Spacer()
            Text(subTotle)
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
            Text(allTotle)
                .frame(alignment: .trailing)
        }
    }
}

#Preview {
    ShoppingCarView()
}
