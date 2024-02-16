//
//  CargoCellView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/16.
//

import SwiftUI
import NukeUI

struct CargoCellView: View {
    
    enum CargoAction {
        case add
        case minus
    }
    
    let item:GoodItem
    let addOrMinus:(_ action:CargoAction, _ item:GoodItem)->Void
    
    @State private var quantity:Int = 999
    
    var body: some View {
        HStack {
            Image(systemName: "fork.knife.circle.fill")
                .frame(width: 50, height: 50)
                .background(Color.gray)
                .cornerRadius(10)
                
            
            Text(item.title)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(item.showPrice)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text("\(item.quantity)")
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            HStack {

                Button {
                    addOrMinus(.minus, item)
                } label: {
                    Image(systemName: "minus.square.fill")
                        .foregroundStyle(Color.init(hex: "#F8F9FA"))
                }
                .buttonStyle(.plain)

                Text("\(item.quantity)")
                    .overlay(
                            Rectangle()
                                .fill(Color.clear) // 透明填充
                                .frame(width: 30), // 强制宽度
                            alignment: .center // 保持内容居中
                        )

                Button {
                    addOrMinus(.add, item)
                } label: {
                    Image(systemName: "plus.app.fill")
                        .foregroundStyle(Color.init(hex: "#F8F9FA"))
                }
                .buttonStyle(.plain)
                
                
                

            }.padding(.horizontal)
            Spacer()

        }.padding()
    }
}

//#Preview {
//    List{
//        CargoCellView()
//
//    }
//    
//}

