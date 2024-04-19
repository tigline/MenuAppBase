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
        optionVo.currentPrice != 0
    }
    
    var optionPrice:String {
        if optionVo.currentPrice < 0 {
            "-¥\(-Int(optionVo.currentPrice))"
        } else {
            "¥\(Int(optionVo.currentPrice))"
        }
    }
    
    var body: some View {
        Button(action: {
            updateOptionlist(optionVo.optionCode, optionVo.group, optionVo.currentPrice)
        }, label: {
            ZStack{
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                    
                        Text(optionVo.mainTitle)
                            .font(CustomFonts.optionButtonFont)
                            .foregroundStyle(isSelected ? .white : .black)
                            .lineLimit(2)
                            
                        Spacer()
                    }
                    .frame(height: 40)
                    .background(isSelected ? selectColor : backgroud)
                    .cornerRadius(8)
                
                }
                
                
                if hasPrice {
                    HStack{
                        Spacer()
                        VStack{
                            Text(optionPrice)
                                .padding(5)
                                .foregroundStyle(.white)
                                .font(.system(size: 12))
                                .background(optionVo.currentPrice>0 ? Color.red:Color.green)
                                .clipCornerRadius(5)
                            Spacer()
                        }.clipped(antialiased: false)
                    }.clipped(antialiased: false)
                    
                }
            }
            .clipped(antialiased: false)
            .frame(height: 45)
            .buttonStyle(.plain)
            
            
        })
        
    }
}

//#Preview {
    //OptionButton(content: "Option", optionCode: "123456")
//}


//                    Spacer()
//                    VStack(alignment: .trailing, content: {
//                        RoundedRightAngleTriangle().fill(
//                            optionVo.currentPrice>0 ? Color.red:Color.green
//                        )
//                        .frame(width: 46, height: 38)
//                        .padding(.leading, -20)
//
//                        .overlay {
//                            Text("\(Int(optionVo.currentPrice))")
//                                .foregroundStyle(.white)
//                                .font(.system(size: 12))
//                                .rotationEffect(.degrees(38))
//                                .padding(.bottom, 10)
//                                .padding(.leading, -12)
//                        }
//                    })
