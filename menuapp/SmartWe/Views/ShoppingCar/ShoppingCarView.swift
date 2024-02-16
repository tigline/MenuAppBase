//
//  ShoppingCarView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/16.
//

import SwiftUI

struct ShoppingCarView: View {
    
    @Environment(\.store.cargoStore) var cargoStore
    
    var body: some View {
        
        VStack {
            List(cargoStore.shoppingCart) { item in
                CargoCellView(item: item, addOrMinus: { action, item in
                    switch action {
                    case .add:
                        cargoStore.addGood(item)
                    case .minus:
                        cargoStore.removeGood(item)
                    }
                })
            }
            
            HStack {
                Spacer()
                VStack(alignment: .trailing, content: {
                    goodsCountView
                    
                    priceCountView
                    
                    totleCountView
                    
                    orderButton
                })
            }.frame(maxWidth: .infinity)
        }
    }
    
    
    
    @ViewBuilder
    var orderButton: some View {
        Button("発信") {
            
        }
        .foregroundStyle(.white)
        .frame(width: 200, height: 50)
        .background(.orange)
        .clipCornerRadius(10)
    }
    
    @ViewBuilder
    var goodsCountView: some View {
        HStack {
            Text("数量")
                .frame(maxWidth: .infinity, alignment: .leading)
            //Spacer()
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
