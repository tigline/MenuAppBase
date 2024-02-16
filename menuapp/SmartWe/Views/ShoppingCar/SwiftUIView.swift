//
//  SwiftUIView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/16.
//

import SwiftUI

struct SwiftUIView: View {
    
    @State private var quantity = 0
    var body: some View {
        VStack {
                Text("\(quantity)")
                Button(action: {
                    quantity += 1
                }) {
                    Text("Increase Quantity")
                }
            }
    }
}

#Preview {
    SwiftUIView()
}
