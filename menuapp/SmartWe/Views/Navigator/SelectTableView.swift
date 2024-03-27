//
//  SelectTableView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/26.
//

import SwiftUI




struct SelectTableView: View {
    @StateObject private var configuration = AppConfiguration.share
    @Environment(\.cargoStore) var cargoStore
    @State private var tableNo:String = ""
    @Environment(\.dismiss) var dimiss
//    @Binding var isPresented:Bool
//    @State private var tableNo:Int
    let columns = [
            GridItem(.adaptive(minimum: 150))
        ]
    let model = Model()
    
    @State private var isLoading:Bool = false
    
    var body: some View {
        
        ZStack {
            
            if model.tableList == nil {
                ProgressView().padding(10)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(model.tableList!, id: \.self) { item in
                            TabelView(tableInfo: item)
                        }
                    }
                }
                .padding()
            }
            
            
        }.task {
            do {
                isLoading = true
                try await model.load(shopCode: configuration.shopCode ?? "")
                isLoading = false
            } catch {
                isLoading = false
                
            }
        }

//        VStack(alignment: .center) {
//            TextField("TableNumber", text: $tableNo)
//                .keyboardType(.numberPad)
//                .padding()
//            Button("Ok") {
//                Task {
//                    await cargoStore.updateTableNumber(tableNo)
//                    configuration.tableNo = tableNo
//                }
//                dimiss()
//            }
//        }
    }
    
}

#Preview {
    SelectTableView()
}


struct ShowInputTableEnvironmentKey: EnvironmentKey {
    static var defaultValue: (String) -> Void = { _ in }
}

extension EnvironmentValues {
    var showInputTableNo: (String) -> Void {
        get { self[ShowInputTableEnvironmentKey.self] }
        set { self[ShowInputTableEnvironmentKey.self] = newValue }
    }
}
