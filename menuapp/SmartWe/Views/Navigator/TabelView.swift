//
//  TabelView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/21.
//

import SwiftUI

struct TabelView: View {
    @StateObject private var configuration = AppConfiguration.share
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

//            Rectangle()
//                    .frame(height: 0.5)
//                    .foregroundColor(theme.themeColor.cargoLine)
            
            HStack {
                
                Text(model.seatCount)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(model.state.textColor)
                    .font(.title3)
                
 
//                Rectangle()
//                        .frame(width: 0.5)
//                        .foregroundColor(.white)
                
                Button {
                    showPopover = true
                } label: {
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(model.state.textColor)
                }
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
                    .alert("是否选定该席位", isPresented: $showAlert) {
                        
                        Button("取消", role: .cancel){
                            
                        }
                        
                        Button("确定"){
                            
                            configuration.tableNo = model.tableInfo.seatNumber + "-" + "\(subTableNo)"
                            configuration.orderKey = model.subTablelOrderkeys[subTableNo]
                            showPopover = false
                        }
                        
                    }
                })

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
