//
//  MovieGalleryContainer.swift
//

import Foundation
import SwiftUI
import TMDb

//struct MenuListView:View {
//    @Environment(\.store.state.appTheme) var theme
//    
//    let category:MenuCategory
//    var body: some View {
//        MenuGalleryLazyVGrid(items: <#[Menu]#>)
//            .background(theme.themeColor.contentBg)
//            .toolbar(.hidden, for: .navigationBar)
//            //.environment(\.isLoading, loader.loading)
//            //.navigationTitle(store.state.sideSelection.localizedString)
//        #if !os(macOS)
//            .navigationBarTitleDisplayMode(.inline)
//        #endif
//    }
//}

struct MovieGalleryDataSource: View {
    let category: Category
    // TODO: 添加 isLoading 提示
    @StateObject private var loader = MoviesGalleryLoader()
    @Environment(\.tmdb) private var tmdb
    @FetchRequest
    private var favoriteMovieIDs: FetchedResults<FavoriteMovie>
    private var source: Source
    // movies from wishlist movie ids
    @State private var wishlistMovies = [Movie]()
    private var movies: AnyRandomAccessCollection<Movie> {
        switch source {
        case .tmdb:
            return AnyRandomAccessCollection(loader)
        case .wishlist:
            return AnyRandomAccessCollection(wishlistMovies)
        }
    }

    init(category: Category) {
        self.category = category
        switch category {
        case .movieWishlist:
            _favoriteMovieIDs = FetchRequest(fetchRequest: FavoriteMovie.movieRequest)
            source = .wishlist
        default:
            source = .tmdb
            _favoriteMovieIDs = FetchRequest(fetchRequest: FavoriteMovie.disableRequest)
        }
    }

    var body: some View {
        MovieGalleryContainer(movies: movies)
            .environment(\.isLoading, loader.loading)
            .onAppear {
                switch source {
                case .tmdb:
                    loader.setLoader(category: category, tmdb: tmdb)
                case .wishlist:
                    break
                }
            }
            .task(id: favoriteMovieIDs.count) {
                guard source == .wishlist else { return }
                wishlistMovies = await Movie.loadWishlistMovieByIDs(tmdb: tmdb, movieIDs: Array(favoriteMovieIDs.map(\.movieID).map(Int.init)))
            }
            .background(AppTheme.Colors.mainBackground)
        #if !os(macOS)
            //.navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
        #endif
    }
}

private extension MovieGalleryDataSource {
    enum Source {
        case tmdb
        case wishlist
    }
}

/*
 // 三种数据源的包装器： Tmdb、wishlist、favoritePerson
  List
  Grid

  NavigationStack
  MovieDetail
  PersonDetail
  TabView
  Settings
  NavigationSplitView

 */
