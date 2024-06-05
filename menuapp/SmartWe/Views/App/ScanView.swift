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
    @State private var showingAlert = false
    @EnvironmentObject private var appConfiguration:AppConfiguration
    
    var body: some View {
        VStack {
            HStack {
                Button("cancel_text") {
                    openScanView = false
                }
                .font(appConfiguration.appLanguage.regularFont(16))
                .padding(.top)
                .padding(.horizontal)
                Spacer()
            }
            ScanViewController(onScanCompleted: { code in
                self.scannedCode = code
                //关闭扫码页面
                openScanView = false

            })
        }.onAppear{
            //检查相机权限
            checkCameraAccess()
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("camera_access_denied")
                    .font(appConfiguration.appLanguage.regularFont(14)),
                message: Text("access_in_settings")
                    .font(appConfiguration.appLanguage.regularFont(14)),
                dismissButton: .default(Text("settings_text")
                    .font(appConfiguration.appLanguage.regularFont(14)), action: {
                    // 跳转到设置应用
                    if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                })
            )
        }
        
    }
    
    func checkCameraAccess() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                // 已授权，无需做任何事情
                break
            case .notDetermined:
                // 未请求权限，发起请求
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if !granted {
                        // 用户拒绝，更新 UI 反映状态
                        showingAlert = true
                    }
                }
            case .denied, .restricted:
                // 权限被拒绝或受限，显示警告提示用户
                showingAlert = true
            @unknown default:
                // 处理未知情况
                break
            }
        }
}

//#Preview {
//    ScanView()
//}
