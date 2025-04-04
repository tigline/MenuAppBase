//
//  File.swift
//
//
//  Created by Yang Xu on /13.
//

import Foundation
import Nuke
import NukeUI
import SwiftUI

struct MenuItemPoster: View {
    private let imagePath: URL?
    private let size: CGSize
    private let showShadow: Bool
    private let enableScale: Bool

    @Environment(\.imagePipeline) private var imagePipeline
    @State private var scale: CGFloat = 1

    init(
        imagePath: URL?,
        size: CGSize,
        showShadow: Bool = false,
        enableScale: Bool = true
    ) {
        self.imagePath = imagePath
        self.size = size
        self.showShadow = showShadow
        self.enableScale = enableScale
    }

    var body: some View {
        VStack {
            if let imageURL {
                LazyImage(url: imageURL) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaleEffect(scale)
                            .animation(.default, value: scale)
                        #if os(macOS)
                            .onContinuousHover(coordinateSpace: .local) { phase in
                                switch phase {
                                case .active:
                                    if enableScale {
                                        scale = 1.2
                                    }
                                case .ended:
                                    scale = 1
                                }
                            }
                        #endif
                    } else {
                        DownloadPlaceHolder()
                    }
                }
                .pipeline(imagePipeline)
            } else {
                DownloadPlaceHolder()
            }
        }
        .frame(width: size.width, height: size.height)
        .clipped()
        .compositingGroup()
        //.background(Color.orange)
        .if(showShadow) {
            $0.shadow(radius: 3)
        }
    }

    var imageURL: URL? {
        guard let path = imagePath else { return nil }
//        return moviePosterURLPrefix
//            .appending(path: "/w300")
//            .appending(path: path.absoluteString)
        return path
    }
}

