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
    
    let item:CargoItem
    let addOrMinus:(_ action:CargoAction, _ item:CargoItem)->Void
    
    @State private var quantity:Int = 999
    
    var body: some View {
        VStack {
            
            
            HStack {
                
                MenuItemPoster(imagePath: URL(string: item.imageUrl ?? ""),
                               size: CGSize(width: 90, height: 60))

                Text(item.title ?? "")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("¥" + "\(Int(item.price))")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text(item.tableNo ?? "Select a Table")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    
                    Button {
                        addOrMinus(.minus, item)
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 10, height: 10)
                            .foregroundStyle(Color.init(hex: "#01000D"))
                    }
                    .frame(width: 30, height: 30)
                    .buttonStyle(BorderlessButtonStyle())
                    .background(Color.init(hex: "#F8F9FA"))
                    .cornerRadius(8)
                    
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
                        Image(systemName: "plus")
                            .frame(width: 10, height: 10)
                            .foregroundStyle(Color.init(hex: "#01000D"))
                    }
                    .frame(width: 30, height: 30)
                    .buttonStyle(BorderlessButtonStyle())
                    .background(Color.init(hex: "#F8F9FA"))
                    .cornerRadius(8)
                    
                }.padding(.vertical)
                
                Spacer()
                
                
            }
            .padding(.vertical, 10)
            .padding(.leading, 45)
            .padding(.trailing, 102)
            .background(.white)
            
            Rectangle()
                    .padding(.horizontal, 21)
                    .frame(height: 0.5)
                    .foregroundColor(.init(hex: "#5C3C23").opacity(0.5))
                    
            
        }
        
    }
}

//#Preview {
//    List{
//        CargoCellView()
//
//    }
//    
//}

