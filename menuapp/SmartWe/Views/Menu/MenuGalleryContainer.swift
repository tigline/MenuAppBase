//
//  MovieGalleryContainer.swift
//

import Foundation
import SwiftUI

struct MenuGalleryLazyVGrid: View {
    @Environment(\.isLoading) private var isLoading
    @Environment(MenuStore.self) var menuStore
    @Environment(\.showError) private var showError
    @EnvironmentObject var configuration: AppConfiguration
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
                        MenuItemView(item: item).frame(minHeight: 150)
                    }
                }
                .padding(.top, 15)
                
                if isLoading {
                    ProgressView()
                        .padding(10)
                    
                }
            }
            .refreshable {
                Task{
                    do{
                        try await menuStore.load(shopCode: configuration.shopCode ?? "",
                                                 machineCode: configuration.machineCode ?? "",
                                                 language: configuration.appLanguage.sourceId)
                    } catch {
                        showError(error,nil)
                    }
                }
                
            }
            .background(theme.themeColor.contentBg)
        }
    }
}

