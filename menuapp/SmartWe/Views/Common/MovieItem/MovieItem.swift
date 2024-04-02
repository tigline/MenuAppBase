//
//  File.swift
//
//

import Foundation
import Nuke
import NukeUI
import SwiftUI
import TMDb
import UIKit

public struct MenuItem: View {
    let item: Menu
    let displayType: DisplayType = .portrait(.middle)
    @Environment(\.goOptions) var goOptions
    @State var geomeFrame: CGRect = .zero
    
    @StateObject private var configuration = AppConfiguration.share
    
    var theme:AppTheme {
        configuration.colorScheme
    }


    private var layout: AnyLayout {
        switch displayType {
        case .portrait:
            return AnyLayout(VStackLayout(alignment: .leading, spacing: 0))
        case .landscape:
            return AnyLayout(HStackLayout(alignment: .center, spacing: 0))
        }
    }

    private var clipShape: AnyShape {
        if displayType == .landscape {
            return AnyShape(Rectangle())
        } else {
            return AnyShape(HalfRoundedRectangle(cornerRadius: 8))
        }
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            
            itemView
                .onTapGesture {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        goOptions(item ,snapshotView(animateView), geomeFrame)
                    }
                }

                .background(
                    GeometryReader { geometry in
                        let renderSize = geometry.frame(in: .global)
                        Color.clear
                            .task(id: renderSize) {
                                geomeFrame = geometry.frame(in: .global) //获取自身Frame
                            }
                    }
                )
            
//            if isPressed {
//                animateView
//                    .frame(width: geomeFrame.width, height: geomeFrame.height)
//                    .clipShape(Circle())
//                    .scaleEffect(animation ? 0.1:1)
//                    .onAppear {
//                        withAnimation(.easeInOut) {
//                            animation.toggle()
//                        } completion: {
//                            DispatchQueue.main.asyncAfter(deadline: .now()) {
//                                
//                                goOptions(snapshotView(animateView), geomeFrame)
//                                
//                            }
//                            
//                            isPressed.toggle()
//                            animation.toggle()
//                            
//                        }
//
//                    }
//            }
        }
       
    }
    

    @ViewBuilder
    var animateView:some View {
        layout {
            MenuItemPoster(
                imagePath: URL(string: item.homeImage),
                size: displayType.imageSize
            )
            ItemShortInfo(
                title: item.mainTitle,
                subtitle: String(Int(item.price)) + " 円",
                displayType: displayType,
                theme: theme.themeColor
            )
            if displayType == .landscape {
                Image(systemName: "chevron.forward")
                    .padding(.trailing, 16)
                    .foregroundColor(.secondary)
            }
        }
        .background(displayType == .landscape ? .clear : AppTheme.Colors.rowBackground)
        .compositingGroup()
        //.clipShape(clipShape)
        .contentShape(Rectangle())
//        .if(displayType != .landscape) { view in
//            view
//                .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 3, x: 0, y: 2)
//        }
    }
    
    @ViewBuilder
    var itemView:some View {
        layout {
            MenuItemPoster(
                imagePath: URL(string: item.homeImage),
                size: displayType.imageSize
            )
            ItemShortInfo(
                title: item.mainTitle,
                subtitle: String(Int(item.price)) + " 円",
                displayType: displayType,
                theme: theme.themeColor
            )
            if displayType == .landscape {
                Image(systemName: "chevron.forward")
                    .padding(.trailing, 16)
                    .foregroundColor(.secondary)
            }
        }
        .background(displayType == .landscape ? .clear : AppTheme.Colors.rowBackground)
        .compositingGroup()
        //.clipShape(clipShape)
        .contentShape(Rectangle())
//        .if(displayType != .landscape) { view in
//            view
//                .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 3, x: 0, y: 2)
//        }
    }
    
    func snapshotView<T: View>(_ view: T) -> UIImage {
        let controller = UIHostingController(rootView: view)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    
}


public enum DisplayType: Equatable {
    case portrait(Size)
    case landscape

    public enum Size: Equatable {
        case tint
        case small
        case middle
        case large
    }

    var imageSize: CGSize {
        switch self {
        case .landscape:
            return .init(width: 86, height: 128)
        case .portrait(.tint):
            return .init(width: 86, height: 128)
        case .portrait(.small):
            return .init(width: 150, height: 223)
        case .portrait(.middle):
            return .init(width: 260, height: 160)
        case .portrait(.large):
            // TODO: - 设置成正确的 Large 尺寸
            return .init(width: 174, height: 260)
        }
    }
}


