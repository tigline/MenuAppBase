//
//  LoginView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/07.
//

import SwiftUI

struct LoginView: View {
    @State private var text: String = ""
//    @State private var showLoginError = false
    @State private var openScanView = false
//    @State private var loginError = "Login failed"
    //@StateObject private var configuration = AppConfiguration.share
    @Environment(\.showError) private var showError
    
    private let model = Model(appData: AppConfiguration.share)


    var body: some View {
        VStack {
            HStack{
                Image("smartwe.logo")
                Text("SmartWe")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.blue)
            }
            
            HStack {
                TextField("input_machine_code", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    
                Button(action: scanAction) {
                    Image(systemName: "camera.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())

            }
            .padding()
            Button("login_text", action: loginAction)
                .buttonStyle(.borderedProminent)

        }
//        .alert("login_failed", isPresented: $showLoginError) {
//            Button("sure_text") {
//                showLoginError = false
//                // Handle the acknowledgement.
//            }
//        } message: {
//            Text(loginError)
//        }
        //弹出ScanView
        .sheet(isPresented: $openScanView, content: {
            ScanView(scannedCode: $text, openScanView: $openScanView)
        })
        .fullScreenCover(isPresented: model.loginSuccess, content: {
            SideBarContainer()
        })
        
        

        
    }
    
    func scanAction() {
        openScanView = true
    }
    
    func loginAction() {
        print("loginAction")
        
        #if DEBUG
        if text == "" {
//            loginError = "machine code should not be empty"
//            showLoginError = true
            text = "hd36G5rUu7bZc5xAMr"
        }
        #endif
        
        Task {
            do {
                try await model.login(shopCode: text)
            } catch {
                showError(error, "Login Failured")
            }
        }
    }
}

#Preview {
    LoginView()
}


