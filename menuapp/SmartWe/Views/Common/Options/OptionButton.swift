//
//  OptionButton.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/13.
//

import SwiftUI

struct OptionButton: View {
    
    @StateObject private var configuration = AppConfiguration.share
    
    var backgroud:Color { .init(hex: "#F7F7F7")}
    var selectColor:Color  { configuration.colorScheme.themeColor.orderBtBg}
    //@Binding var selected:Bool
    let optionVo:OptionVo
    
    @Environment(\.updateOptionlist) var updateOptionlist
    @Environment(\.inOptionlist) var inOptionlist
    
    
    private var isSelected: Bool {
        return inOptionlist(optionVo.optionCode, optionVo.group)
    }
    
    var hasPrice:Bool {
        optionVo.currentPrice > 0
    }
    
    var body: some View {
        Button(action: {
            updateOptionlist(optionVo.optionCode, optionVo.group, optionVo.currentPrice)
        }, label: {
            HStack{
                Spacer()
                Text(optionVo.mainTitle)
                    .font(CustomFonts.optionButtonFont)
                    .foregroundStyle(isSelected ? .white : .black)
                    .lineLimit(2)
                if hasPrice {
                    Spacer()
                    VStack(alignment: .trailing, content: {
                        RoundedRightAngleTriangle().fill(configuration.colorScheme.themeColor.orderBtBg)
                            .frame(width: 36, height: 32)
                            .padding(.leading, -20)
                            .overlay {
                                Text("+" + "\(Int(optionVo.currentPrice))")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 10))
                                    .rotationEffect(.degrees(38))
                                    .padding(.bottom, 10)
                                    .padding(.leading, -12)
                            }
                        Spacer()
                    })
                    
                } else {
                    Spacer()
                }
            }
            .frame(height: 40)
            .buttonStyle(.plain)
            .background(isSelected ? selectColor : backgroud)
            .cornerRadius(8)
        })
        
    }
}

//#Preview {
    //OptionButton(content: "Option", optionCode: "123456")
//}


