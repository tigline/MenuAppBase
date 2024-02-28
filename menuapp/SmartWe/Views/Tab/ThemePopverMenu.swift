//
//  ThemePopverMenu.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/09.
//

import SwiftUI

struct ThemePopverMenu: View {
    @Environment(\.theme) var theme
    @Binding var showPopover:Bool
    var body: some View {
            VStack(alignment: .leading) {
                Button(action: {
                    theme(.orange)
                    showPopover = false
                }, label: {
                    HStack {
                        Text("")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(8)
                    .background(AppTheme.orange.themeColor.buttonColor)
                    .cornerRadius(10)
                })
                .buttonStyle(.plain)
                    
                Button(action: {
                    theme(.dark)
                    showPopover = false
                }, label: {
                    HStack {
                        Text("")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(8)
                    .background(AppTheme.dark.themeColor.mainBackground)
                    .cornerRadius(10)
                })
                .buttonStyle(.plain)
                    
                Button(action: {
                    theme(.brown)
                    showPopover = false
                }, label: {
                    HStack {
                        Text("")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(8)
                    .background(AppTheme.brown.themeColor.mainBackground)
                    .cornerRadius(10)
                })
                .buttonStyle(.plain)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
}

//#Preview {
//    ThemePopverMenu()
//}
