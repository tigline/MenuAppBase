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
            updateOptionlist(optionVo.optionCode, optionVo.group)
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


struct RoundedRightAngleTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let curveSize: CGFloat = 13.0 // 控制曲线大小
        
        // 三角形的三个顶点
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let TopRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        // 开始绘制路径
        path.move(to: topLeft)
        
        // 添加到右上角的线
        path.addLine(to: CGPoint(x: TopRight.x, y: TopRight.y - curveSize))
    
        
        // 添加到右下角的线
        path.addLine(to: bottomRight)
        
        // 完成闭合路径
        path.closeSubpath()
        
        return path
    }
}
