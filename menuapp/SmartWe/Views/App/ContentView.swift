//
//  ContentView.swift
//

import Combine
import SwiftUI
import SwiftUIOverlayContainer

struct ContentView: View {
    @StateObject var appConfiguration = AppConfiguration.share
    @Environment(\.scenePhase) private var scenePhase
    
    
    private let model = Model()

    var body: some View {
        VStack {
            LoginView()
        }
        
        //.syncCoreData() // 同步 booking list 数据
        //.preferredColorScheme(.light)
        .environment(\.locale, appConfiguration.appLanguage.locale)
        .onChange(of: scenePhase) { old, newScenePhase in
            switch newScenePhase {
            case .active:
                if appConfiguration.tableNo != nil && appConfiguration.orderKey != nil {
                    Task {
                        await model.startCheck(appConfiguration.shopCode,appConfiguration.orderKey)
                    }
                }
            case .inactive:
                print("App is inactive")
            case .background:
                print("App is in background")
                //stop check
                model.stopRepeatingTask()
            default:
                break
            }
        }
        .onChange(of: appConfiguration.orderKey) { oldValue, newValue in
            
            if newValue == nil {
                model.stopRepeatingTask()
                return
            }
            
            if appConfiguration.tableNo != nil && newValue != nil {
                Task {
                    await model.startCheck(appConfiguration.shopCode,newValue)
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
