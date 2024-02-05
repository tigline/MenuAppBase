//
//  DownloadPlaceHolder.swift
//

import Foundation
import SwiftUI

struct DownloadPlaceHolder: View {
    let size: ControlSize
    init(size: ControlSize = .large) {
        self.size = size
    }

    var body: some View {
        Rectangle()
            .fill(Assets.Colors.imagePlaceHolder)
            .overlay(
                ProgressView()
                    .controlSize(size)
                    .opacity(0.5)
            )
    }
}

struct DownloadPlaceHolder_Preview: PreviewProvider {
    static var previews: some View {
        DownloadPlaceHolder()
            .frame(width: 100, height: 200)
    }
}
