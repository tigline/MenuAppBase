//
//  File.swift
//
//
//  Created by Yang Xu on /13.
//

import Foundation
import SwiftUI
import TMDb

struct ItemShortInfo: View {
    let title: String
    let subtitle: String
    let displayType: DisplayType
    let theme:ThemeColors

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
            .background(theme.mainBackground)
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
            .background(theme.mainBackground)
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
            .font(.callout)
            .lineLimit(1)
            .foregroundColor(theme.textColor)
    }
    
    @ViewBuilder
    var subTitleView: some View {
        VStack {
            Text(subtitle)
                .font(.title2)
                .foregroundColor(theme.textColor)
        }
    }
    
    @ViewBuilder
    var addButton: some View {
        Button(action:{}) {
            Image(systemName:"plus")
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                
//                .font(.callout)
//                .bold()
//                .alignmentGuide(.top) { _ in -8 }
        }
        .frame(width: 32, height: 32)
        .buttonStyle(BorderlessButtonStyle())
        .background(theme.buttonColor)
        .cornerRadius(10)
        
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

struct MovieShortInfo: View {
    let movie: Movie?
    let displayType: DisplayType

    var body: some View {
        switch displayType {
        case .portrait:
            VStack(alignment: .leading, spacing: 8) {
                rateView
                movieNameView.padding(.trailing, 8)
                HStack(alignment: .bottom) {
                    releaseDateView
                    durationView
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 13)
            .frame(width: displayType.imageSize.width, alignment: .leading)
        case .landscape:
            VStack(alignment: .leading, spacing: 8) {
                movieNameView
                HStack(alignment: .bottom, spacing: 8) {
                    rateView
                    releaseDateView
                    durationView
                }
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // 评分
    @ViewBuilder
    var rateView: some View {
        HStack(spacing: 3) {
            if let movie {
                if let rate = movie.voteAverage {
                    Image(systemName: "star")
                        .symbolVariant(.fill)
                        .foregroundColor(.orange)

                    Text(rate, format: .number.precision(.fractionLength(1)))
                } else {
                    Text(verbatim: "")
                        .foregroundColor(.secondary)
                }
            } else {
                Text(verbatim: "")
                    .foregroundColor(.secondary)
            }
        }
        .font(.footnote)
    }

    // 电影名称
    @ViewBuilder
    var movieNameView: some View {
        Text(movie?.title ?? " ")
            .font(.callout)
            .lineLimit(1)
    }

    // 发行年份
    @ViewBuilder
    var releaseDateView: some View {
        VStack {
            if let movie {
                if let releaseDate = movie.releaseDate {
                    Text(releaseDate, format: .dateTime.year(.defaultDigits))
                } else {
                    Text("Coming_Soon")
                }
            } else {
                Text(" ")
            }
        }
        .foregroundColor(.secondary)
        .font(.footnote)
    }

    // 电影时长
    @ViewBuilder
    var durationView: some View {
        if let movie, let duration = movie.runtime {
            let now = Date(timeIntervalSince1970: 0)
            let later = now + TimeInterval(duration) * 60
            let timeDuration = (now ..< later).formatted(.components(style: .narrow))
            Text(timeDuration)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

#if DEBUG
    struct MovieShortInfoPreview: PreviewProvider {
        static var previews: some View {
            HStack(spacing: 0) {
//                Rectangle()
//                    .fill(.orange.gradient)
//                    .frame(width: DisplayType.portrait(.middle).imageSize.width,
//                           height: DisplayType.portrait(.middle).imageSize.height)
                ItemShortInfo(title: "Title",
                              subtitle: "Subtitle",
                              displayType: .portrait(.middle),
                              theme: .init(mainBackground: Color("darkMain"),
                                           buttonColor: Color("darkGrey"),
                                           darkRed: Color("darkRed"),
                                           textColor: .white))

            }
            .padding(8)
            .frame(width: 310)
            .previewLayout(.sizeThatFits)
            .border(.gray)
            .environment(\.calendar, .init(identifier: .gregorian))
            .environment(\.locale, .init(identifier: "zh-cn"))

//            VStack(spacing: 0) {
//                Rectangle()
//                    .fill(.orange.gradient)
//                    .frame(width: DisplayType.portrait(.small).imageSize.width,
//                           height: DisplayType.portrait(.small).imageSize.height)
//
//            }
//            .border(.gray)
//
//            VStack(spacing: 0) {
//                Rectangle()
//                    .fill(.orange.gradient)
//                    .frame(width: DisplayType.portrait(.middle).imageSize.width,
//                           height: DisplayType.portrait(.middle).imageSize.height)
//  
//            }
            .border(.gray)
        }
    }
#endif
