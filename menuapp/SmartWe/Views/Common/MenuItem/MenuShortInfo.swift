//
//  File.swift
//
//
//  Created by Yang Xu on /13.
//

import Foundation
import SwiftUI

struct ItemShortInfo: View {
    let title: String
    let subtitle: String
    let displayType: DisplayType
    let theme:ThemeColors
    let config:AppConfiguration

    var body: some View {
        switch displayType {
        case .portrait:
            HStack(alignment: .center, spacing: 8) {
                
                VStack(alignment: .leading, spacing: 8) {
                    titleView.padding(.trailing, 8)
                    subTitleView.padding(.trailing, 8)
                }
                
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    addButton
                }
                
                
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .frame(width: displayType.imageSize.width, alignment: .leading)
            .background(theme.shortInfoBg)
        case .landscape:
            VStack(alignment: .leading, spacing: 8) {
                titleView
                HStack(alignment: .bottom, spacing: 8) {
                    subTitleView
                    addButton
                }
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.shortInfoBg)
        }
    }


//    @ViewBuilder
//    var rateView: some View {
//        HStack(spacing: 3) {
//            if let movie {
//                if let rate = movie.voteAverage {
//                    Image(systemName: "star")
//                        .symbolVariant(.fill)
//                        .foregroundColor(.orange)
//
//                    Text(rate, format: .number.precision(.fractionLength(1)))
//                } else {
//                    Text(verbatim: "")
//                        .foregroundColor(.secondary)
//                }
//            } else {
//                Text(verbatim: "")
//                    .foregroundColor(.secondary)
//            }
//        }
//        .font(.footnote)
//    }


    @ViewBuilder
    var titleView: some View {
        Text(title)
            .font(config.appLanguage.regularFont(13))
            .lineLimit(1)
            .foregroundColor(theme.shortInfoText)
    }
    
    @ViewBuilder
    var subTitleView: some View {
        VStack {
            Text(subtitle)
                .font(config.appLanguage.semiBoldFont(15))
                .foregroundColor(theme.shortInfoText)
        }
    }
    
    @ViewBuilder
    var addButton: some View {
        VStack {
            Image(systemName:"plus")
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                
//                .font(.callout)
//                .bold()
//                .alignmentGuide(.top) { _ in -8 }
        }
        .frame(width: 32, height: 32)
        .buttonStyle(BorderlessButtonStyle())
        .background(theme.addButtonBg)
        .cornerRadius(8)
        
    }


//    @ViewBuilder
//    var releaseDateView: some View {
//        VStack {
//            if let movie {
//                if let releaseDate = movie.releaseDate {
//                    Text(releaseDate, format: .dateTime.year(.defaultDigits))
//                } else {
//                    Text("Coming_Soon")
//                }
//            } else {
//                Text(" ")
//            }
//        }
//        .foregroundColor(.secondary)
//        .font(.footnote)
//    }


//    @ViewBuilder
//    var durationView: some View {
//        if let movie, let duration = movie.runtime {
//            let now = Date(timeIntervalSince1970: 0)
//            let later = now + TimeInterval(duration) * 60
//            let timeDuration = (now ..< later).formatted(.components(style: .narrow))
//            Text(timeDuration)
//                .font(.footnote)
//                .foregroundColor(.secondary)
//        }
//    }
}

