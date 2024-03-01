//
//  OptionGroupListView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/13.
//

import SwiftUI

struct OptionGroupListView: View {
    @Environment(\.menuStore.menuOptionState) var menuOptionState
    @Environment(\.menuStore) var menuStore
    @Environment(\.cargoStore) var cargoStore
    @Environment(\.imagePipeline) private var imagePipeline
    @StateObject private var configuration = AppConfiguration.share
    
    @Binding var isShowing: Bool
    var body: some View {
        ZStack {
            // 半透明背景
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                        
                    }
                }
            HStack(alignment:.top, spacing: 1, content:  {
                //image area
                VStack(spacing: 15, content: {

                    AsyncImage(url: URL(string:  menuOptionState?.images.first ?? "")) { image in
                        image
                            .resizable()
                            //.aspectRatio(contentMode: .fit)
                            //.scaledToFit()
                            .clipped()
                            
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxHeight: .infinity)
                    .clipCornerRadius(8)
                    
                    
                    HStack(spacing: 15, content: {
                        
                        AsyncImage(url: URL(string:  menuOptionState?.images.first ?? "")) { image in
                            image
                                .resizable()
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                        .clipCornerRadius(8)
                        
                        AsyncImage(url: URL(string:  menuOptionState?.images.first ?? "")) { image in
                            image
                                .resizable()
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                        .clipCornerRadius(8)

                    })
                    .frame(height: 150)
                    
                })
                .padding()
                .frame(width: 360)
                
                //option area
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading, spacing: 20, content: {
                        Text(menuOptionState?.mainTitle ?? "")
                            .font(CustomFonts.optionTitle1Font)
                            .foregroundStyle(.black)
                        Text(menuOptionState?.subTitle ?? "")
                            .font(CustomFonts.optionDetailFont)
                            .foregroundStyle(AppTheme.Colors.optionDetailColor)
                        optionView
                    })
                    closeButton
                    
                }
                .padding()
                
            })
            .frame(height: 540)
            .background(.white)
            .clipCornerRadius(10)
            .padding(.horizontal,60)
        }
        .environment(\.inOptionlist) {
            menuStore.inOptionlist($0, $1)
        }
        .environment(\.updateOptionlist) {code,groud in
            menuStore.updateSelectOption(code, groud)
        }
        
        
    }
    
    @ViewBuilder
    var closeButton: some View {
        Button {
            withAnimation {
                isShowing = false
            }
        } label: {
            Image("close")
        }
    }
    
    @ViewBuilder
    var optionView: some View {
        
        VStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading) {
                    if let optionGroups = menuOptionState?.optionList {
                        ForEach(optionGroups) { optionGroup in
                            OptionListView(option: optionGroup)
                        }
                    }
                }
                
            }
            .scrollIndicators(.hidden)
            
            VStack(alignment: .center, content: {
                Button(action: {
                    // 你的按钮行为
                    guard let menuOptionState = menuStore.menuOptionState else {
                        return
                    }
                    cargoStore.addGood(menuOptionState.optionGoodInfo.0,
                                       price: menuOptionState.optionGoodInfo.1,
                                       options: menuOptionState.optionGoodInfo.2)
                    
                    withAnimation {
                        isShowing = false
                    }
                }) {
                    Text("確認する")
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle()) // 确保整个按钮区域都能响应点击
                }
                .background(configuration.colorScheme.themeColor.orderBtBg)
                .clipCornerRadius(10)
                .padding(.horizontal, 100)
                .buttonStyle(.plain)
                
            })
            //.padding(.bottom, 50)
            .frame(maxWidth: .infinity)
        }
        
        
    }
}

extension View {
    func clipCornerRadius(_ cornerRadius:CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
    
    func rightHalfRadius(_ cornerRadius:CGFloat) -> some View {
        clipShape(RightHalfRoundedRectangle(radius: cornerRadius))
    }
}

struct RightHalfRoundedRectangle: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        path.addLine(to: CGPoint(x: topRight.x - radius, y: topRight.y))
        path.addArc(center: CGPoint(x: topRight.x - radius, y: topRight.y + radius), radius: radius, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - radius))
        path.addArc(center: CGPoint(x: bottomRight.x - radius, y: bottomRight.y - radius), radius: radius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        path.closeSubpath()
        
        return path
    }
}

//#Preview {
//    @State var isShow:Bool = false
//    OptionGroupListView(optionGroups: sampleOptionGroups, isShowing: $isShow)
//}
