//
//  OptionGroupListView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/13.
//

import SwiftUI

struct OptionGroupListView: View {
    //@Environment(\.menuStore.menuOptionState) var menuOptionState
    //@Environment(\.menuStore) var menuStore
    //@Environment(\.goOptions) var addGood
    @Environment(\.imagePipeline) private var imagePipeline
    @Environment(\.soundPlayer) private var soundPlayer
    @EnvironmentObject var configuration: AppConfiguration

    @State private var isLandscape:Bool = false
    
    @State var model: Model
    @Binding var isShowing: Bool
    let isShowAdd: ()->Void

    var body: some View {
        GeometryReader { geometry in

            ZStack {
                // 半透明背景
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        //withAnimation {
                            isShowing = false
                            
                        //}
                    }
                HStack(alignment:.top, spacing: 1, content:  {
                    //image area
                    VStack(spacing: 15, content: {
                        
                        AsyncImage(url: URL(string: model.images.first ?? "")) { image in
                            image
                                .resizable()
                                //.scaledToFit()
                                .aspectRatio(1, contentMode: .fit)
                                .clipped()
                            
                        } placeholder: {
                            ProgressView()
                        }
                        .clipCornerRadius(8)
                        
                        Text(model.subTitle)
                            .font(CustomFonts.optionDetailFont)
                            .foregroundStyle(AppTheme.Colors.optionDetailColor)
                    })
                    .padding()
                    .frame(width: 360)
                    
                    //option area
                    ZStack(alignment: .topTrailing) {
                        VStack(alignment: .leading, spacing: 20, content: {
                            HStack {
                                Text(model.mainTitle)
                                    .font(CustomFonts.optionTitle1Font)
                                    .foregroundStyle(.black)
                                Spacer()
                                Text("¥ " + "\(model.totlePrice)")
                                    .font(CustomFonts.cargoTotalPriceFont)
                                    .foregroundStyle(configuration.colorScheme.themeColor.orderBtBg)
                            }
                            .padding(.trailing, 60)

                            
                            optionView
                        })
                        closeButton
                            .padding(.top, -10)
                            .padding(.trailing, -10)
                        
                    }
                    .padding()
                })
                .frame(height: 540)
                .background(.white)
                .clipCornerRadius(10)
                .padding(.leading, isLandscape ? 260:60)
                .padding(.trailing, 60)
            }
            .environment(\.inOptionlist) {
                model.inOptionlist($0, $1)
            }
            .environment(\.updateOptionlist) {code,groud,price in
                model.updateOption(code, groud, price)
            }
            .onAppear {
                isLandscape = geometry.size.width > geometry.size.height
            }
            .onChange(of: geometry.size.width, initial: false) { oldWidth, newWidth in
                isLandscape = newWidth > geometry.size.height
            }
            
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
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
    }
    
    @ViewBuilder
    var optionView: some View {
        
        VStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading) {
                    ForEach(model.optionList) { optionGroup in
                        OptionListView(option: optionGroup)
                    }
                }
            }
            .scrollIndicators(.hidden)
            
            VStack(alignment: .center, content: {
                Button(action: {
                    soundPlayer.playSound(soundFileName: "14428")
                    withAnimation {
                        isShowing = false
                    } completion: {
                        model.addGood(table: configuration.tableNo ?? "")
                        isShowAdd()
                    }
                }) {
                    Text("sure_text")
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



//#Preview {
//    @State var isShow:Bool = false
//    OptionGroupListView(optionGroups: sampleOptionGroups, isShowing: $isShow)
//}
//                        HStack(spacing: 15, content: {
//
//                            AsyncImage(url: URL(string:  model.images.first ?? "")) { image in
//                                image
//                                    .resizable()
//                                    .clipped()
//                            } placeholder: {
//                                ProgressView()
//                            }
//                            .clipCornerRadius(8)
//
//                            AsyncImage(url: URL(string:  model.images.first ?? "")) { image in
//                                image
//                                    .resizable()
//                                    .clipped()
//                            } placeholder: {
//                                ProgressView()
//                            }
//                            .clipCornerRadius(8)
//
//                        })
//                        .frame(height: 150)
