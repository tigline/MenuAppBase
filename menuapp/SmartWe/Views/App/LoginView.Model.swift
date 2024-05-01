//
//  LoginView.Model.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/04/25.
//

import Foundation
import SwiftUI

extension LoginView {
    
    @Observable
    class Model {
        
        var loginSuccess:Binding<Bool> {
            Binding<Bool>(
                get: { self.appData.loginState == .login },
                set: { _ in  }
            )
        }
        
        let appData:AppConfiguration
        init(appData: AppConfiguration) {
            self.appData = appData
        }
        
        @MainActor
        func login(shopCode:String) async throws {
            let request = APIRequest(resource: LoginResource(machineCode: shopCode))

            do {
                let result = try await request.execute()
                if result.code == 200 {
                    appData.machineCode = result.data.machineCode
                    appData.shopCode = result.data.shopCode
                    appData.logoImage = result.data.logoImage
                    appData.appLanguage = .jp //result.data.languages[0]
                    appData.loginState = .login
                }
                
            } catch {
                print("login error:" + error.localizedDescription)
                throw error//NSError(domain: "login", code: 0, userInfo: [NSLocalizedDescriptionKey:"Login Failured"])
            }
            
        }
        
        
    }
    
}

struct LoginResource:APIResource {
    typealias ModelType = Response<MachineInfo>
    
    var path: String = "/pad/web/ipad/activate"
    
    var method: HttpMethod = .POST
    
    var body: Data? {
        ["machineCode":machineCode
        ].toJSONData() ?? Data()
    }
    
    let machineCode:String
}


enum LoginState:Int, CaseIterable, Identifiable {
    case logout
    case login
    
    var id:Self {
        return self
    }
}
