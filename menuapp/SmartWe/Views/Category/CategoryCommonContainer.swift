//
//  CategoryCommon.swift
//

import Foundation
import SwiftUI
import TMDb

struct CategoryCommonContainer: View {
    let category: Category
    var body: some View {
        VStack(spacing: 0) {
            ViewMoreButton(
                title: category.localizedString,
                destination: category.destination
            )
            CategoryCommonScrollView(category: category)
        }
        .background(Assets.Colors.rowBackground)
        .frame(maxWidth: .infinity)
    }
}

#if DEBUG
    struct CategoryCommonContainer_Previews: PreviewProvider {
        static var previews: some View {
            CategoryCommonContainer(
                category: .popular
            )

            CategoryCommonContainer(
                category: .topRate
            )
        }
    }
#endif
