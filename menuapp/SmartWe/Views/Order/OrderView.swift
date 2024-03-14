//
//  OrderView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/22.
//

import SwiftUI



struct OrderView: View {
    
    @Environment(\.orderStore) var orderStore
    @Environment(\.showError) var showError
    @StateObject private var configuration = AppConfiguration.share
    
    var body: some View {
        VStack {
            Text("Empty")
        }
        .frame(maxHeight:.infinity)
        
    }
}

#Preview {
    OrderView()
}

