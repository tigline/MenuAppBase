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
    @Environment(\.showTable) var showTable
    
    @StateObject private var configuration = AppConfiguration.share
    @FetchRequest(fetchRequest: CargoItem.CargoRequest)
    private var shoppingCart: FetchedResults<CargoItem>

    @State private var showSuccess:Bool = false
    @State private var showOrder:Bool = false
    //var checkTimer:Timer?
    
    
    var theme:AppTheme {
        configuration.colorScheme
    }
    
    
    var isNoTableNo:Bool {
        configuration.tableNo == nil || configuration.tableNo == ""
    }
    
    var goodsCount:String {
        let count = shoppingCart.reduce(into: 0) { count, item in
            count += item.quantity
        }
        return "\(count)"
    }
    
    var subTotal:String {
        allTotal
    }
    

    
    var showOrderReminder:Bool {
        let nowTime = Date().timeIntervalSince1970
        let lastItemTime = configuration.lastChangedDate
        // more than 5 minutes
        if nowTime - lastItemTime > 30 && !shoppingCart.isEmpty {
            return true
        }
        return false
    }
    
    var allTotal:String {
        let all = shoppingCart.reduce(0) { count, item in
            count + item.price * Double(item.quantity)
        }
        return "\(Int(all))"
    }
    
    var body: some View {
        
        if shoppingCart.isEmpty && !showSuccess {
            VStack {
                ContentUnavailableView {
                    Label("", systemImage: "exclamationmark.circle")
                        .foregroundStyle(theme.themeColor.toolBarTextBgOff)
                } description: {
                    Text("ご注文ください")
                        .foregroundStyle(theme.themeColor.toolBarTextBgOff)
                        .font(.title2)
                }
            }
            .background(theme.themeColor.mainBackground)
            .padding(20)
        } else {
            VStack(spacing: 0) {
                ScrollView(.vertical) {
                    LazyVStack(content: {
                        ForEach(shoppingCart.reversed()) { item in
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
//            .sheet(isPresented: $showTable) {
//                SelectTableView()
//            }
            .alert("ご注文あれがどうございました", isPresented: $showSuccess) {
                Button {
                    showSuccess = false
                    Task {
                        try await cargoStore.cleanShoppingCar(table: configuration.tableNo ?? "")
                    }
                    
                } label: {
                    Text("確認")
                        .contentShape(Rectangle())
                }

            }
            .alert("ご注文しましょうか", isPresented: $showOrder) {
                Button {
                    Task {
                        print("sendCarToOrder start")
                        orderAction()
                        
                    }
                } label: {
                    Text("確認")
                        .contentShape(Rectangle())
                }
                Button {
                    configuration.lastChangedDate = Date().timeIntervalSince1970
                } label: {
                    Text("继续点餐")
                        .contentShape(Rectangle())
                }

            }
//            .onAppear{
//                showOrder = showOrderReminder
//            }
        }
            
    }
    
    func orderAction()  {
        Task {
            print("sendCarToOrder start")
            await cargoStore.sendCarToOrder(shoppingCart: shoppingCart.map({$0}),
                                            language: configuration.menuLaguage ?? "",
                                            shopCode: configuration.shopCode ?? "",
                                            machineCode: configuration.machineCode ?? "",
                                            orderKey: configuration.orderKey ?? "",
                                            totalPrice: allTotal,
                                            errorHandle: { error in
                if let getError = error {
                    showError(getError, "Please try again")
                } else {
                    showSuccess.toggle()
                }
            })
            
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
                    showTable(true)
                }
                .foregroundStyle(.white)
                .frame(minWidth: 200, minHeight: 50)
                .background(theme.themeColor.buttonColor)
                .clipCornerRadius(10)
            } else {
                
                Button {
                    Task {
                        print("sendCarToOrder start")
                        orderAction()
                        
                    }
                } label: {
                    Text("発信")
                        .frame(maxWidth: .infinity)

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
            Text(allTotal)
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
            Text(allTotal)
                .font(CustomFonts.cargoTotalPriceFont)
                .frame(alignment: .trailing)
                .foregroundStyle(theme.themeColor.cargoTextColor)
        }
    }
}

//#Preview {
//    ShoppingCarView(, showTable: <#Binding<Bool>#>)
//}
