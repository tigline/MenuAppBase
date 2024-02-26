//
//  ContentView.swift
//

import Combine
import SwiftUI
import SwiftUIOverlayContainer

struct ContentView: View {
    @Environment(\.store) var store
    @StateObject private var appConfiguration = AppConfiguration.share
    @State private var errorWrapper: ErrorWrapper?
    @State private var isPresentError:Bool = false


    var body: some View {
        VStack {
            #if !os(macOS)
            if appConfiguration.loginState == .login {
                SideBarContainer()
            } else {
                LoginView()
            }
                
            #else
                StackContainer()
            #endif
        }
//        .if(containerName != ""){
//            $0.overlayContainer(containerName, containerConfiguration: ContainerConfiguration.share)
//        }
//        .environment(\.containerName, containerName)
        .environment(\.showError) { error, guidance in
            errorWrapper = ErrorWrapper(error: error, guidance: guidance)
            isPresentError = true
        }
        .alert(errorWrapper?.error.localizedDescription ?? "Error",
               
               isPresented: $isPresentError, actions: {
            Button("Ok") {
                isPresentError = false
            }
        }, message: {
            Text(errorWrapper?.guidance ?? "")
        })
        
        .syncCoreData() // 同步 booking list 数据
        .preferredColorScheme(.light)
        .environment(\.locale, appConfiguration.appLanguage.locale)
        .setDeviceStatus()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        #if os(iOS)
            ContentView()
                //.environmentObject(Store())
                .environment(\.deviceStatus, .compact)
                .previewDevice(.iPhoneName)

            ContentView()
                //.environmentObject(Store())
                .environment(\.deviceStatus, .regular)
                .previewDevice(.iPadName)
        #else
            ContentView()
                //.environmentObject(Store())
                .environment(\.deviceStatus, .macOS)
        #endif
    }
}
