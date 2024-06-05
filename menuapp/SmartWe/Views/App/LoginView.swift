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
    
    @Environment(\.showError) private var showError
    @EnvironmentObject var appConfiguration: AppConfiguration
    
    @State var menuStore = MenuStore(appService: AppService.appDefault)
    
    private var model: Model = Model()
    
    var loginSuccess:Binding<Bool> {
        Binding<Bool>(
            get: { appConfiguration.loginState == .login },
            set: { _ in  }
        )
    }


    var body: some View {
        VStack {
            HStack{
                Image("smartwe.logo")
                Text("SmartWe")
                    .font(appConfiguration.appLanguage.regularFont(18))
                    .bold()
                    .foregroundStyle(.blue)
            }
            
            HStack {
                TextField("input_machine_code", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(appConfiguration.appLanguage.regularFont(16))
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
                .font(appConfiguration.appLanguage.regularFont(16))
                .buttonStyle(.borderedProminent)

        }
        .alert("login_failed", isPresented: $showLoginError) {
            Button("sure_text") {
                //showLoginError = false
                // Handle the acknowledgement.
            }
            .font(appConfiguration.appLanguage.regularFont(16))
        } message: {
            Text(LocalizedStringKey(loginError))
        }
        .font(appConfiguration.appLanguage.regularFont(16))
        //弹出ScanView
        .sheet(isPresented: $openScanView, content: {
            ScanView(scannedCode: $text, openScanView: $openScanView)
        })
        .fullScreenCover(isPresented: loginSuccess, content: {
            SideBarContainer().environment(menuStore)
        })
        
        

        
    }
    
    func scanAction() {
        openScanView = true
    }
    
    func loginAction() {
        print("loginAction")

        if text == "" {
//#if DEBUG
//            text = "hd36G5rUu7bZc5xAMr"
//#else
            loginError = "machine_code_empty"
            showLoginError = true
//#endif
        }
        
        
        Task {
            do {
                menuStore.selectBarIndex = 0
                let machineInfo = try await model.login(shopCode: text)
                appConfiguration.machineCode = machineInfo.machineCode
                appConfiguration.shopCode = machineInfo.shopCode
                appConfiguration.logoImage = machineInfo.logoImage
                appConfiguration.loginState = .login
            } catch {
                loginError = "machine_code_error"
                showLoginError = true
            }
        }
    }
}

#Preview {
    LoginView()
}


