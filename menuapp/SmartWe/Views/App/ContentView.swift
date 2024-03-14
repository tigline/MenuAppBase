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
    @State private var alertWrapper: AlertWrapper?
    @State private var isPresentAlert:Bool = false
    @State private var isPresentError:Bool = false

    var body: some View {
        VStack {
            if appConfiguration.loginState == .login {
                SideBarContainer()
            } else {
                LoginView()
            }
        }
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
        .environment(\.showAlert) { title, content in
            alertWrapper = AlertWrapper(title: title, content: content)
            isPresentAlert = true
        }
        .alert(alertWrapper?.title ?? "",
               
               isPresented: $isPresentAlert, actions: {
            Button("Ok") {
                isPresentAlert = false
            }
        }, message: {
            Text(alertWrapper?.content ?? "")
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
