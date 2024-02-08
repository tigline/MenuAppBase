//
//  LoginView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/07.
//

import SwiftUI

struct LoginView: View {
    @State private var text: String = ""
    @State private var showLoginError = false
    @State private var openScanView = false
    @State private var loginError = "Login failed"
    @Environment(\.store) var store
    @StateObject private var configuration = AppConfiguration.share
    @Environment(\.smartwe) var smartwe
    var body: some View {
        VStack {
            HStack{
                Image("smartwe.logo")
                Text("SmartWe")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.blue)
                
            }
            
            //输入框与扫码一体化
            HStack {
                TextField("请输入设备码", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    
                
                Button(action: scanAction) {
                    Image(systemName: "camera.viewfinder")
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
                

            }
            .padding()
            Button("Login", action: loginAction)
                .buttonStyle(.borderedProminent)
                
            
            
        }.alert("Login failed", isPresented: $showLoginError) {
            Button("OK") {
                showLoginError = false
                // Handle the acknowledgement.
            }
        } message: {
            Text(loginError)
        }
        //弹出ScanView
        .sheet(isPresented: .constant(openScanView), content: {
            ScanView(scannedCode: $text, openScanView: $openScanView)
        })
        
        

        
    }
    
    func scanAction() {
        openScanView = true
    }
    
    func loginAction() {
        
        print("loginAction")
        
        if text == "" {
            loginError = "machine code should not be empty"
            showLoginError = true
            return
        }
    
        Task {
            let result = try await smartwe.activeDevice(machineCode: text)
            if result.code == 200 {
                store.send(.updateMachineInfo(result.data))
                configuration.machineCode = result.data.machineCode
                configuration.shopCode = result.data.shopCode
                configuration.logoImage = result.data.logoImage
                configuration.menuLaguage = result.data.languages[0]
                configuration.loginState = .login
            } else {
                showLoginError = true
            }
        }
    }
}

#Preview {
    LoginView()
}


enum LoginState:Int, CaseIterable, Identifiable {
    case logout
    case login
    
    var id:Self {
        return self
    }
}
