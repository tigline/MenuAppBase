//
//  OptionButton.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/13.
//

import SwiftUI

struct OptionButton: View {
    @State var content:String
    @State var backgroud:Color = .init(hex: "#F7F7F7")
    @State var selectColor:Color = .orange
    //@Binding var selected:Bool
    @State var price:Int = 999
    var body: some View {
        Button(action: {}, label: {
            HStack{
                Text(content).padding(.leading)
                
                
                VStack(alignment: .trailing, content: {
                    RoundedRightAngleTriangle().fill(.orange)
                        .frame(width: 66, height: 50)
                        .padding(.leading, -20)
                        .overlay {
                            Text("+" + "\(price)")
                                .foregroundStyle(.white)
                                .rotationEffect(.degrees(38))
                                .padding(.bottom, 15)
                        }
                    Spacer()
                })
                
            }
        })
        .background(backgroud)
        .frame(height: 60)
        .buttonStyle(.plain)
        .cornerRadius(13)
    }
}

#Preview {
    OptionButton(content: "Option")
}

import SwiftUI

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
