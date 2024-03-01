//
//  ShoppingCarView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/16.
//

import SwiftUI

struct ShoppingCarView: View {
    
    @Environment(\.cargoStore) var cargoStore
    @Environment(\.showError) var showError
    @StateObject private var configuration = AppConfiguration.share
    @FetchRequest(fetchRequest: CargoItem.CargoRequest)
    private var shoppingCart: FetchedResults<CargoItem>
    @State private var showTable:Bool = false
    
    var theme:AppTheme {
        configuration.colorScheme
    }
    
//    var showLoading:Binding<Bool> {
//        Binding<Bool> {
//            cargoStore.showOrderAnimate
//        } set: { value, _ in
//            cargoStore.toggleAnimate(value)
//        }
//
//    }
    
    var isNoTableNo:Bool {
        configuration.tableNo == nil || configuration.tableNo == ""
    }
    
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
        return "\(Int(all))"
    }
    
    
    var body: some View {
        
        if shoppingCart.isEmpty {
            VStack {
                ContentUnavailableView("ご注文ください", systemImage: "exclamationmark.circle")
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
                            .padding(.bottom, 12)
                        priceCountView
                            .padding(.bottom, 18)
                        totleCountView
                            .padding(.bottom, 20)
                        orderButton
                            .padding(.bottom, 35)
                    }
                    
                }
                .padding(.trailing, 120)
                .background(theme.themeColor.mainBackground)
                .frame(height: 220)
            }
            .padding(20)
            .background(theme.themeColor.contentBg)
            .overlay {
                cargoStore.showOrderAnimate ? OrderProgressView:nil
            }
            .sheet(isPresented: $showTable) {
                SelectTableView()
            }
        }
            
    }
    
    @ViewBuilder
    var OrderProgressView: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                Spacer()
                Text("注文しています、お待ちしてください")
            }
            .padding()
            .frame(maxWidth: 200, maxHeight: 200)
            .background(.white)
            .clipCornerRadius(15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.black.opacity(0.3))
    }
    
    
    @ViewBuilder
    var orderButton: some View {
        HStack {
            Spacer()
            
            if isNoTableNo {
                Button("Select a Table") {
                    showTable.toggle()
                }
                .foregroundStyle(.white)
                .frame(minWidth: 200, maxHeight: 50)
                .background(theme.themeColor.buttonColor)
                .clipCornerRadius(10)
            } else {
                Button("発信") {
                    
                    Task {
                        
                        await cargoStore.sendCarToOrder(shoppingCart: shoppingCart.map({$0}),
                                                        language: configuration.menuLaguage ?? "en",
                                                        machineCode: configuration.machineCode ?? "",
                                                        errorHandle: { error in
                            showError(error, "Please try again")
                        })
                    }
                }
                .foregroundStyle(.white)
                .frame(width: 200, height: 50)
                .background(theme.themeColor.orderBtBg)
                .clipCornerRadius(10)
            }
        }
        
    }
    
    @ViewBuilder
    var goodsCountView: some View {
        HStack {
            Text("数量")
                .font(CustomFonts.cargoCountFont)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(theme.themeColor.cargoTextColor)
            Spacer()
            Text(goodsCount)
                .font(CustomFonts.cargoCountFont)
                .frame(alignment: .trailing)
                .foregroundStyle(theme.themeColor.cargoTextColor)
        }
    }
    
    @ViewBuilder
    var priceCountView: some View {
        HStack {
            Text("小计")
                .frame(alignment: .leading)
                .font(CustomFonts.cargoCountFont)
                .foregroundStyle(theme.themeColor.cargoTextColor)
            Spacer()
            Text(subTotle)
                .frame(alignment: .trailing)
                .font(CustomFonts.cargoCountFont)
                .foregroundStyle(theme.themeColor.cargoTextColor)
        }
    }
    
    @ViewBuilder
    var totleCountView: some View {
        HStack {
            Text("合计")
                .font(CustomFonts.cargoTotalFont)
                .frame(alignment: .leading)
                .foregroundStyle(theme.themeColor.cargoTextColor)
            Spacer()
            Text(allTotle)
                .font(CustomFonts.cargoTotalPriceFont)
                .frame(alignment: .trailing)
                .foregroundStyle(theme.themeColor.cargoTextColor)
        }
    }
}

#Preview {
    ShoppingCarView()
}
