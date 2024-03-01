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
//     let category: Category?
//     let genreID: Genre.ID?
    let displayType: DisplayType = .portrait(.middle)
    @Environment(\.goOptions) var goOptions
    @State private var isPressed: Bool = false
    @State var geomeFrame: CGRect = .zero
    @State var animation: Bool = false
    @StateObject private var configuration = AppConfiguration.share
    @State private var snapshotImage: UIImage? = nil
    var theme:AppTheme {
        configuration.colorScheme
    }

    private var showBookMark: Bool {
        configuration.showBookMarkInPoster
    }

//    init(
//        item: Menu?,
//        category: Category? = nil,
//        genreID: Genre.ID? = nil,
//        displayType: DisplayType,
//        namespace: Namespace.ID,
//        menu: Menu
//    ) {
//        self.item = item
//        self.category = category
//        self.genreID = genreID
//        self.displayType = displayType
//        self.namespace = namespace
//        self.selectedItem = menu
//    }

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
                    isPressed.toggle()
                    //goOptions(item, geomeFrame)
                }

                .background(
                    GeometryReader { geometry in
                        let renderSize = geometry.frame(in: .global)
                        Color.clear
                            .task(id: renderSize) {
                                geomeFrame = geometry.frame(in: .global)
                            }
                    }
                )
            
            if isPressed {
                animateView
                    .frame(width: geomeFrame.width, height: geomeFrame.height)
                    .clipShape(Circle())
                    .scaleEffect(animation ? 0.2:1)
                    .onAppear {
                        withAnimation {
                            animation.toggle()
                        } completion: {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                
                                goOptions(snapshotView(animateView), geomeFrame)
                                
                            }
                            
                            isPressed.toggle()
                            animation.toggle()
                            
                        }

                    }
            }
            
            
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


public struct MovieItem: View {
    private let movie: Movie?
    private let category: Category?
    private let genreID: Genre.ID?
    private let displayType: DisplayType

    @Environment(\.goDetailFromHome) private var goDetailFromHome
    @Environment(\.goDetailFromCategory) private var goDetailFromCategory
    @Environment(\.colorScheme) private var colorScheme
    @State private var isPressed: Bool = false
    @StateObject private var configuration = AppConfiguration.share
    private var showBookMark: Bool {
        configuration.showBookMarkInPoster
    }

    init(
        movie: Movie?,
        category: Category? = nil,
        genreID: Genre.ID? = nil,
        displayType: DisplayType
    ) {
        self.movie = movie
        self.category = category
        self.genreID = genreID
        self.displayType = displayType
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
            Button {
                guard let movie else { return }
                let destinationCategory: Category = category ?? (genreID != nil ? .genre(genreID!) : .popular)
                // from movie gallery
                if category == nil && genreID == nil {
                    goDetailFromCategory(movie)
                } else {
                    goDetailFromHome(destinationCategory, movie)
                }
            } label: {
                layout {
                    ItemPoster(
                        movie: movie,
                        size: displayType.imageSize
                    )
//                    MovieShortInfo(
//                        movie: movie,
//                        displayType: displayType
//                    )
                    if displayType == .landscape {
                        Image(systemName: "chevron.forward")
                            .padding(.trailing, 16)
                            .foregroundColor(.secondary)
                    }
                }
                .background(displayType == .landscape ? .clear : AppTheme.Colors.rowBackground)
                .compositingGroup()
                .clipShape(clipShape)
                .contentShape(Rectangle())
                .if(displayType != .landscape) { view in
                    view
                        .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 3, x: 0, y: 2)
                }
            }
            .buttonStyle(.pressStatus($isPressed))
            if showBookMark {
                BookMarkCornerButton(movieID: movie?.id)
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1)
        .animation(.easeOut.speed(2), value: isPressed)
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

#if DEBUG
    struct MovieItemTest: View {
        @State var favorite: Bool = false
        var body: some View {
            MovieItem(
                movie: .previewMovie1,
                displayType: .portrait(.small)
            )
            .border(.gray)
            .padding(10)
            .environment(\.inWishlist) { _ in favorite }
            .environment(\.updateWishlist) { _ in favorite.toggle() }
        }
    }

    struct MovieItem_Previews: PreviewProvider {
        static var previews: some View {
            VStack {
                MovieItemTest()

                MovieItem(
                    movie: .previewMovie1,
                    displayType: .portrait(.small)
                )
                .environment(\.inWishlist) { _ in true }

                MovieItem(
                    movie: .previewMovie1,
                    displayType: .portrait(.large)
                )
            }
        }
    }
#endif
