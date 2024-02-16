//
//  OptionGroupListView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/13.
//

import SwiftUI
import NukeUI

struct OptionGroupListView: View {
    @Environment(\.store.menuStore.menuOptionState) var menuOptionState
    @Environment(\.store.menuStore) var menuStore
    @Environment(\.store.cargoStore) var cargoStore
    @Environment(\.imagePipeline) private var imagePipeline
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
            HStack(alignment:.top, content:  {
                //image area
                VStack(spacing: 10, content: {
                    LazyImage(url: URL(string:  menuOptionState?.images.first ?? ""))
                        .pipeline(imagePipeline)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 280, height: 300)
                        .clipCornerRadius(10)
                    HStack(spacing: 10, content: {
                        LazyImage(url: URL(string:  menuOptionState?.images.last ?? ""))
                            .pipeline(imagePipeline)
                            //.aspectRatio(contentMode: .fill)
                            .frame(width: 135, height: 130)
                            .clipCornerRadius(10)
                            .clipped()
                        LazyImage(url: URL(string:  menuOptionState?.images.last ?? ""))
                            .pipeline(imagePipeline)
                            //.aspectRatio(contentMode: .fill)
                            .frame(width: 135, height: 130)
                            .clipCornerRadius(10)
                            .clipped()
                    })
                    
                })
                .frame(width: 280, height: 440)
                .padding()
                //option area
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading, spacing: 20, content: {
                        Text(menuOptionState?.mainTitle ?? "")
                            .font(.title)
                        Text(menuOptionState?.subTitle ?? "")
                            .font(.subheadline)
                        optionView
                    })
                    closeButton
                    
                }
                .frame(height: 440)
                .padding()
                
            })
            .background(.white)
            .clipCornerRadius(10)
            .padding(.horizontal,100)
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
            Image(systemName: "xmark.circle")
        }
    }
    
    @ViewBuilder
    var optionView: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                if let optionGroups = menuOptionState?.optionList {
                    ForEach(optionGroups) { optionGroup in
                        OptionListView(option: optionGroup)
                    }
                }
                VStack(alignment: .center, content: {
                    Button("確認する") {
                        
                        guard let menuOptionState = menuStore.menuOptionState else {
                            return
                        }
                        cargoStore.addGood(menuOptionState.optionGoodInfo.0,
                                           price: menuOptionState.optionGoodInfo.1,
                                           options: menuOptionState.optionGoodInfo.2)
                        
                        withAnimation {
                            isShowing = false
                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 100)
                    .buttonStyle(.plain)
                    .foregroundStyle(.white)
                    .background(.orange)
                    .clipCornerRadius(10)
                    
                })
                .padding(.top, 50)
                .frame(maxWidth: .infinity)
            }
            
        }
        .scrollIndicators(.hidden)
    }
}

extension View {
    func clipCornerRadius(_ cornerRadius:CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

//#Preview {
//    @State var isShow:Bool = false
//    OptionGroupListView(optionGroups: sampleOptionGroups, isShowing: $isShow)
//}
