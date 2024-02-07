//
//  ScanView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/07.
//

import SwiftUI
import AVFoundation

struct ScanView: View {
    @Binding var scannedCode: String
    @Binding var openScanView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    openScanView = false
                }
                .padding(.top)
                .padding(.horizontal)
                Spacer()
            }
            ScanViewController(onScanCompleted: { code in
                self.scannedCode = code
                //关闭扫码页面
                openScanView = false

            })
        }
        
    }
}

//#Preview {
//    ScanView()
//}
