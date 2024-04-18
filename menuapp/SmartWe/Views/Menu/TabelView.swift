//
//  TabelView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/21.
//

import SwiftUI

struct TabelView: View {
    @StateObject private var configuration = AppConfiguration.share
    @Environment(\.cargoStore) var cargoStore
    @State private var showPopover = false
    @State private var showAlert = false
    @State private var subTableNo:Int = 0
    @State private var orderKey:String = ""

    private var theme:AppTheme {
        configuration.colorScheme
    }
    
    private var model:Model {
        Model(tableInfo: tableInfo)
    }
    
    let tableInfo:TableInfo
    
    var body: some View {
        VStack(spacing: 0){
            
            VStack {
                
                Text(model.floor)
                    .foregroundColor(.white)
                    .font(.title3)
                
                Text(model.tableInfo.seatNumber)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                Text(model.state.localizedString)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                    .font(.title3)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.init(hex: "#D2B48C"))
            
            HStack {
                
                Text(model.seatCount)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(model.state.textColor)
                    .font(.title3)
                
                if model.subTablelOrderkeys.count > 0 {
                    
//                    Button {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            showPopover = true
//                        }
//                    } label: {
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(model.state.textColor)
                    //}
                    .frame(width: 44)
                    .popover(isPresented: $showPopover, content: {
                        //LanguagePopverMenu(showPopover: $showPopover)
                        VStack {
                            ForEach(model.subTablelOrderkeys.indices, id: \.self) { index in
                                Button {
                                    if model.subTablelOrderkeys[index].isEmpty {
                                        
                                    } else {
                                        subTableNo = index
                                        showAlert = true
                                    }
                                } label: {
                                    Text(model.subTableInfo(index))
                                        .frame(maxWidth: .infinity, minHeight:44)
                                        .padding(.horizontal)
                                        .foregroundStyle(.white)
                                        .background(model.seatButtonColor(index))
                                        .clipCornerRadius(8)
                                }
                                
                            }
                        }
                        .padding()
                        .alert("select_table_title", isPresented: $showAlert) {
                            
                            Button("cancel_text", role: .cancel){
                                
                            }
                            
                            Button("sure_text"){
                                Task{
                                    configuration.tableNo = model.tableInfo.seatNumber + "-" + "\(subTableNo+1)"
                                    configuration.orderKey = model.subTablelOrderkeys[subTableNo]
                                    
                                    await cargoStore.updateTableNumber(configuration.tableNo)
                                    
                                    print("\(model.subTablelOrderkeys)")
                                    showPopover = false
                                }
                                
                            }
                            
                        }
                    })
                }

            }
            .frame(height: 44)
            .background(model.state.bgColor)
            .onTapGesture {
                showPopover = true
            }
            
        }
        .cornerRadius(10)
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
        
        
        
    }
}



//#Preview {
//    TabelView()
//}
