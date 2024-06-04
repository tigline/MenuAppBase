//
//  TabelView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/03/21.
//

import SwiftUI

struct TabelView: View {
    
    
    @State private var showPopover = false
    @State private var showAlert = false
    @State private var subTableNo:Int = 0
    @State private var orderKey:String = ""
    @Binding var currentShowIndex:String?
    
    @Environment(\.showError) private var showError
    


    private var theme:AppTheme {
        model.appData.colorScheme
    }
    
    private var model:Model {
        Model(tableInfo: tableInfo, appData: AppConfiguration.share)
    }
    
    private var shopCode:String {
        model.appData.shopCode ?? ""
    }
    
    let tableInfo:TableInfo
    
    var isBlur:Bool {
        currentShowIndex != nil && currentShowIndex != model.tableInfo.seatNumber
    }
    
    var body: some View {
        ZStack {
            Button {
                //showPopover.toggle()
                if currentShowIndex == nil {
                    currentShowIndex = model.tableInfo.seatNumber
                }
                
                //print("item = \(model.tableInfo.seatNumber) Popover = \(showPopover)")
            } label: {
                VStack(spacing: 0){
                    
                    VStack {
                        
                        Text(model.floor)
                            .foregroundColor(.white)
                            .font(.title3)
                        
                        Text(model.tableInfo.seatNumber)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.init(hex: "#D2B48C"))
                    
                    HStack {
                        
                        Text(model.seatCount)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(model.state.textColor)
                            .font(.title3)
                        
                        if model.subTablelOrderkeys.count > 0 {
                            
                            Image(systemName: "chevron.forward")
                                .foregroundStyle(model.state.textColor)
                                .frame(width: 44)
                                .disabled(currentShowIndex != nil && currentShowIndex != model.tableInfo.seatNumber)
                                .popover(isPresented: Binding(
                                    get: { currentShowIndex == model.tableInfo.seatNumber },
                                    set: { if !$0 { currentShowIndex = nil } }
                                ), content: {
                                    VStack {
                                        ForEach(model.subTablelOrderkeys.indices, id: \.self) { index in
                                            Button {
                                                subTableNo = index
                                                showAlert.toggle()
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
                                                
                                                do {
                                                    try await model.openSeat(shopCode:shopCode,
                                                                             seatNumber:model.tableInfo.seatNumber,
                                                                             subSeat:subTableNo)
                                                } catch {
                                                    showError(error,nil)
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                })
                            
                        }
                        
                    }
                    .frame(height: 44)
                    .background(model.state.bgColor)
                    
                    
                }
                .blur(radius: isBlur ? 5:0)
                .cornerRadius(10)
                .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
                
            }
//            if currentShowIndex != nil && currentShowIndex != model.tableInfo.seatNumber {
//                Color.black.opacity(0.5)
//                    
//                    .blur(radius: 20)
//                    .cornerRadius(10)
//                    .allowsHitTesting(false)
//                    
//            }
        }
        

            
            
        }

        
}



//#Preview {
//    TabelView()
//}
