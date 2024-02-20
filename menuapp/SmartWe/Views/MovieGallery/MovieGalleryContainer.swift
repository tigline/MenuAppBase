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

struct MovieGalleryContainer: View {
    let movies: AnyRandomAccessCollection<Movie>
    @Environment(\.deviceStatus) private var deviceStatus

    var body: some View {
        VStack {
            switch deviceStatus {
            case .macOS, .regular:
                GalleryLazyVGrid(movies: movies)
            case .compact:
                GalleryLazyVStack(movies: movies)
            }
        }
        .animation(.default, value: movies.count)
    }
}

//struct MenuGalleryLazyVGrid: View {
//    let items: [Menu]
//    @Environment(\.isLoading) private var isLoading
//    @Environment(\.goOptions) var goOptions
//    private let minWidth: CGFloat = DisplayType.portrait(.middle).imageSize.width + 10
//    var body: some View {
//        ScrollView(.vertical) {
//            let columns: [GridItem] = [.init(.adaptive(minimum: minWidth))]
//            LazyVGrid(columns: columns, spacing: 18.5) {
//                ForEach(items) { item in
//                    MenuItem(item: item, displayType: .portrait(.middle), onTap: {
//                        withAnimation {
//                            goOptions(item)
//                        }
//                    })
//                }
//            }
//            .padding(.top, 15)
////            .padding(.horizontal, 32)
//            if isLoading {
//                ProgressView()
//                    .padding(10)
//            }
//            
//        }
//    }
//}





struct MenuGalleryLazyVGrid: View {
    
    let items:[Menu]
    @Environment(\.isLoading) private var isLoading
    @Environment(\.goOptions) var goOptions
    @Environment(\.store.menuStore.cartIconGlobalFrame) var cartIconGlobalFrame
    @Environment(\.store.state.appTheme) var theme
    // 新增状态变量
    @State private var selectedItemId: String?
    @State private var animateToCart: Bool = false
    @State private var showDetailView = false
    @State private var animationStartFrame: CGRect = .zero
    @State private var selectedItem: Menu? = nil
    
    private let minWidth: CGFloat = DisplayType.portrait(.middle).imageSize.width + 10
    
    var body: some View {
        // 使用 GeometryReader 获取购物车图标的位置
        ZStack {
            ScrollView(.vertical) {
                let columns: [GridItem] = [.init(.adaptive(minimum: minWidth))]
                LazyVGrid(columns: columns, spacing: 18.5) {
                    ForEach(items) { item in
                        MenuItem(item: item, displayType: .portrait(.middle))
                            .onTapGesture {
                                
                                withAnimation {
                                    showDetailView = true
                                }
                            }
                            .background(GeometryReader { geometry -> Color in
                                if selectedItem == item && showDetailView {
                                    animationStartFrame = geometry.frame(in: .global)
                                    //goOptions(item, animationStartFrame)
                                }
                                return Color.clear
                            })
                        //                    .scaleEffect(animateToCart && selectedItemId == item.menuCode ? 0.1 : 1)
                        //                    .position(x: animateToCart && selectedItemId == item.menuCode ? cartIconGlobalFrame.midX : geometry.frame(in: .global).minX,
                        //                              y: animateToCart && selectedItemId == item.menuCode ? cartIconGlobalFrame.midY : geometry.frame(in: .global).minY)
                    }
                }
                .padding(.top, 15)
                
                if isLoading {
                    ProgressView()
                        .padding(10)
                    
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .background(theme.themeColor.contentBg)
            
            if showDetailView, let selectedItem = selectedItem {
                
                DetailView2(text: selectedItem.mainTitle)
                    .frame(width: 200, height: 200)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 10)
                                .position(x: animationStartFrame.midX, y: animationStartFrame.midY)
                                .scaleEffect(showDetailView ? 1 : 0)
                                .offset(y: showDetailView ? UIScreen.main.bounds.midY - animationStartFrame.midY : 0)
                                .animation(.spring(), value: showDetailView)
            }
            
        }
    }
}


struct DetailView2: View {
    let text:String
    var body: some View {
        //OptionGroupListView(isShowing: $showDetailView)
        VStack {
            Text("text")
        }
        
    }
}



struct GalleryLazyVGrid: View {
    let movies: AnyRandomAccessCollection<Movie>
    @Environment(\.isLoading) private var isLoading
    private let minWidth: CGFloat = DisplayType.portrait(.middle).imageSize.width + 10
    var body: some View {
        ScrollView(.vertical) {
            let columns: [GridItem] = [.init(.adaptive(minimum: minWidth))]
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(movies) { movie in
                    MovieItem(movie: movie, displayType: .portrait(.middle))
                }
            }
            .padding(.vertical, 20)
            if isLoading {
                ProgressView()
                    .padding(10)
            }
        }
    }
}

struct GalleryLazyVStack: View {
    let movies: AnyRandomAccessCollection<Movie>
    @Environment(\.isLoading) private var isLoading
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(movies) { movie in
                    VStack(spacing: 0) {
                        Divider().frame(height: 0.3)
                        MovieItem(movie: movie, displayType: .landscape)
                            .padding(.vertical, 10)
                        if movie.id == movies.last?.id {
                            Divider().frame(height: 0.3)
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            if isLoading {
                ProgressView()
                    .padding(10)
            }
        }
    }
}

struct MovieGalleryContainer_Previews: PreviewProvider {
    static var previews: some View {
        MovieGalleryContainer(
            movies: AnyRandomAccessCollection(
                [
                    .previewMovie1,
                    .previewMovie2,
                ]
            )
        )
        .frame(width: 400)
        .environment(\.deviceStatus, .compact)
        .previewDevice(.iPhoneName)

        MovieGalleryContainer(
            movies: AnyRandomAccessCollection(
                [
                    .previewMovie1,
                    .previewMovie2,
                ]
            )
        )
        .environment(\.deviceStatus, .regular)
        .frame(width: 400)
        .previewDevice(.iPadName)
    }
}
