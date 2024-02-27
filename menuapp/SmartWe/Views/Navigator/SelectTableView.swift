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
    let rows = [
            GridItem(.fixed(30), spacing: 1),
            GridItem(.fixed(60), spacing: 10),
            GridItem(.fixed(90), spacing: 20),
            GridItem(.fixed(10), spacing: 50)
        ]
    var body: some View {
        VStack(alignment: .center) {
            TextField("TableNumber", text: $tableNo)
                .keyboardType(.numberPad)
                .padding()
            Button("Ok") {
                Task {
                    await cargoStore.updateTableNumber(tableNo)
                    configuration.tableNo = tableNo
                }
                dimiss()
            }
        }
    }
    
}

//#Preview {
//    SelectTableView(isPresented: true) as! any View
//}


struct ShowInputTableEnvironmentKey: EnvironmentKey {
    static var defaultValue: (String) -> Void = { _ in }
}

extension EnvironmentValues {
    var showInputTableNo: (String) -> Void {
        get { self[ShowInputTableEnvironmentKey.self] }
        set { self[ShowInputTableEnvironmentKey.self] = newValue }
    }
}
