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
    
    var allTotal: String {
        let all = shoppingCart.reduce(0) { count, item in
            count + item.price * Double(item.quantity)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 设置数字格式为十进制，这将包括千位分隔符
        formatter.groupingSeparator = "," // 设置千位分隔符为逗号，可以根据地区需要调整
        formatter.groupingSize = 3 // 设置分组的大小为3位数字

        let formattedNumber = formatter.string(from: NSNumber(value: Int(all)))
        return formattedNumber ?? "\(Int(all))"
    }

    var sendTotal: String {
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
                    Text("not_shopping_tips")
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
//                        priceCountView
//                            .padding(.bottom, 18)
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
            .alert("order_success_tips", isPresented: $showSuccess) {
                Button {
                    showSuccess = false
                    Task {
                        try await cargoStore.cleanShoppingCar(table: configuration.tableNo ?? "")
                    }
                    
                } label: {
                    Text("sure_text")
                        .contentShape(Rectangle())
                }

            }
//            .alert("ご注文しましょうか", isPresented: $showOrder) {
//                Button {
//                    Task {
//                        print("sendCarToOrder start")
//                        orderAction()
//                        
//                    }
//                } label: {
//                    Text("sure_text")
//                        .contentShape(Rectangle())
//                }
//                Button {
//                    configuration.lastChangedDate = Date().timeIntervalSince1970
//                } label: {
//                    Text("继续点餐")
//                        .contentShape(Rectangle())
//                }
//
//            }
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
                                            totalPrice: sendTotal,
                                            tableNo: configuration.tableNo ?? "",
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
                Text("ordering_tips")
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
                Button("select_a_table") {
                    showTable(true)
                }
                .padding(.horizontal)
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
                    Text("shopping_car_to_order")
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
            Text("item_count")
                .font(CustomFonts.orderCountFont)
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
            Text("shopping_price")
                .frame(alignment: .leading)
                .font(CustomFonts.cargoCountFont)
                .foregroundStyle(theme.themeColor.cargoTextColor)
            Spacer()
            Text("¥ "+allTotal)
                .frame(alignment: .trailing)
                .font(CustomFonts.cargoCountFont)
                .foregroundStyle(theme.themeColor.cargoTextColor)
        }
    }
    
    @ViewBuilder
    var totleCountView: some View {
        HStack {
            Text("all_shopping_price")
                .font(CustomFonts.cargoTotalFont)
                .frame(alignment: .leading)
                .foregroundStyle(theme.themeColor.cargoTextColor)
            Spacer()
            Text("¥ "+allTotal)
                .font(CustomFonts.cargoTotalPriceFont)
                .frame(alignment: .trailing)
                .foregroundStyle(theme.themeColor.cargoTextColor)
        }
    }
}

//#Preview {
//    ShoppingCarView(, showTable: <#Binding<Bool>#>)
//}
