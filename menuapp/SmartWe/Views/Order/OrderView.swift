//
//  OrderView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/22.
//

import SwiftUI



struct OrderView: View {
    
    @Environment(\.showError) var showError
    @StateObject var configuration = AppConfiguration.share
    @State private var model = Model()
    
    private var theme:AppTheme {
        configuration.colorScheme
    }
    
    private var shopCode:String {
        return configuration.shopCode ?? ""
    }
    
    private var table:String {
        return configuration.orderKey ?? ""
    }
    
    private var machineCode:String {
        configuration.machineCode ?? ""
    }
    
    private var language:String {
        configuration.appLanguage.sourceId
    }
    
    var body: some View {
        VStack {
            
            if model.allOrderList.isEmpty {
                VStack {
                    ContentUnavailableView {
                        Label("", systemImage: "exclamationmark.circle")
                            .foregroundStyle(theme.themeColor.toolBarTextBgOff)
                    } description: {
                        Text("not_booking_tips")
                            .foregroundStyle(theme.themeColor.toolBarTextBgOff)
                            .font(.title2)
                    }
                    .background(theme.themeColor.mainBackground)
                }
                .padding(20)
                
                
            } else {
                
                
                VStack(spacing: 0) {
                    List{
                        ForEach(model.allOrderList, id: \.id) { item in
                            OrderCellView(imageUrl: item.image ?? "",
                                          orderTime: item.orderTime ?? "",
                                          title: item.mainTitle ?? "",
                                          optionInfo: item.optionVoListMsgMap ?? [:],
                                          quntity: item.qty,
                                          price: item.price)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .background(theme.themeColor.mainBackground)

                    }
                    .listStyle(PlainListStyle())
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
                                .padding(.bottom, 35)
//                            orderButton
//                                .padding(.bottom, 35)
                        }
                        
                    }
                    .padding(.trailing, 120)
                    .frame(height: 220)
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(theme.themeColor.mainBackground)
                            .shadow(radius: 1, x: 0, y: -1)
                    )
                }
                .padding(20)
                .background(theme.themeColor.contentBg)
            }
            
        }
        .task {
            await loadTask(table: table, lan: language)
        }
        .frame(maxHeight:.infinity)
        .background(theme.themeColor.contentBg)
        
        .onChange(of: configuration.orderKey) { oldValue, newValue in
            
            Task{
                if newValue != nil {
                    await loadTask(table: table, lan: language)
                } else {
                    model.clearOrder()
                }
            }
        }
        .onChange(of: configuration.appLanguage) { oldValue, newValue in
            Task{
                await loadTask(table: table, lan: newValue.sourceId)
            }
        }
        
        
    }
    
    private func loadTask(table:String, lan:String) async {
        do {
            try await model.fetchOrders(shopCode: shopCode,
                                        machineCode: machineCode,
                                        table: table,
                                        lan: lan)
        } catch {
            showError(error, nil)
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
            Text(model.totalQty)
                .font(CustomFonts.cargoCountFont)
                .frame(alignment: .trailing)
                .foregroundStyle(theme.themeColor.cargoTextColor)
        }
    }
    
    @ViewBuilder
    var priceCountView: some View {
        HStack {
            Text("amount_price")
                .frame(alignment: .leading)
                .font(CustomFonts.orderCountFont)
                .foregroundStyle(theme.themeColor.cargoTextColor)
            Spacer()
            
            Text("¥ " + model.totalPrice)
                .font(CustomFonts.cargoTotalFont)
                .foregroundStyle(theme.themeColor.orderBtBg)
            + Text("tax_flog")
                .font(CustomFonts.cargoCountFont)
                .foregroundStyle(theme.themeColor.cargoTextColor)
        }
    }
    
    @ViewBuilder
    var totleCountView: some View {
        HStack {
            Text("tax_price")
                .font(CustomFonts.orderCountFont)
                .frame(alignment: .leading)
                .foregroundStyle(theme.themeColor.cargoTextColor)
            Spacer()
            Text(model.allTax)
                .font(CustomFonts.cargoCountFont)
                .frame(alignment: .trailing)
                .foregroundStyle(theme.themeColor.cargoTextColor)
        }
    }
    
    @ViewBuilder
    var orderButton: some View {
        HStack {
            Spacer()
            
            Button(action: {
                Task {
                    print("sendCarToOrder start")
                }
            }, label: {
                Text("お会計")
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
            })
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .frame(width: 200, height: 50)
            .background(theme.themeColor.orderBtBg)
            .clipCornerRadius(10)
        }
        
        
    }
}

#Preview {
    OrderView()
}

