//
//  ImageView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/29.
//
import Foundation
import Nuke
import NukeUI
import SwiftUI


struct ImageView: View {
    @Environment(\.imagePipeline) private var imagePipeline
    let imagePath: URL?
    var body: some View {
        VStack {
            if let imageURL {
                LazyImage(url: imageURL) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            //.scaleEffect(scale)
                            //.animation(.default, value: scale)
                    } else {
                        DownloadPlaceHolder()
                    }
                }
                .pipeline(imagePipeline)
            } else {
                DownloadPlaceHolder()
            }
        }
        //.frame(width: size.width, height: size.height)
        .clipped()
        .compositingGroup()
        //.background(Color.orange)

    }
    var imageURL: URL? {
        guard let path = imagePath else { return nil }
        return path
    }
}

//#Preview {
//    ImageView()
//}
