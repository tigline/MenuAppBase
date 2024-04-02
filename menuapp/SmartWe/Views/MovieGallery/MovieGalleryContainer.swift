//
//  MovieGalleryContainer.swift
//

import Foundation
import SwiftUI
import TMDb

//struct MenuGalleryContainer: View {
//    
//    @Environment(\.deviceStatus) private var deviceStatus
//    @Environment(\.store.menuStore)
//    var body: some View {
//        VStack {
//            MenuGalleryLazyVGrid(items: menuCategory.menuVoList)
//        }
//        //.animation(.default, value: menuCategory.menuVoList.count)
//    }
//}




struct MenuGalleryLazyVGrid: View {
    @Environment(\.isLoading) private var isLoading
    @Environment(\.menuStore) var menuStore
    @StateObject private var configuration = AppConfiguration.share
    var theme:AppTheme {
        configuration.colorScheme
    }

    @State private var animationStartFrame: CGRect = .zero

    private let minWidth: CGFloat = DisplayType.portrait(.middle).imageSize.width + 10

    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                let columns: [GridItem] = [.init(.adaptive(minimum: minWidth))]
                LazyVGrid(columns: columns, spacing: 18.5) {
                    ForEach(menuStore.curMenuInfo?.menuVoList ?? []) { item in
                        MenuItem(item: item)
                    }
                }
                .padding(.top, 15)
                
                if isLoading {
                    ProgressView()
                        .padding(10)
                    
                }
            }
            .background(theme.themeColor.contentBg)
        }
    }
}

