//
//  OrderButton.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/08.
//

import SwiftUI

struct OrderButton: View {
    //@Environment(\.store.state.appTheme) var theme
    
    let icon:String
    let text:String
    let bgColor:Color
    let onTap:()->Void
    
    var body: some View {
        Button(action: {
            onTap()
        }, label: {
            HStack {
                Label(text, image: icon)
                    .foregroundColor(.white)
                
            }
            .padding(8)
            .background(bgColor)
            .cornerRadius(10)
        })
        .buttonStyle(.plain)
    }
}

//#Preview {
//    OrderButton()
//}
