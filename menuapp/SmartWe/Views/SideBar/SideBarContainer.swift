//
//  TabViewContainer.swift
//

import Foundation
import SwiftUI
//import CoreData

struct SideBarContainer: View {
    @EnvironmentObject var configuration: AppConfiguration

    @Environment(MenuStore.self) var menuStore
    @Environment(\.cargoStore) var cargoStore
    @Environment(\.soundPlayer) private var soundPlayer
    
    @State var isLoading = false
    @StateObject private var animationManager = AnimationQueueManager()
    @State private var carGoAnimation = false
    @State private var showAddAnimation = false
    @State private var showOptions = false
    @State private var selectItem:UIImage?
    @State private var animationItemFrame = CGRect.zero

    @State private var errorWrapper: ErrorWrapper?
    @State private var alertWrapper: AlertWrapper?
    @State private var isPresentAlert:Bool = false
    @State private var isPresentError:Bool = false
    
    
    var theme:AppTheme {
        configuration.colorScheme
    }
    
    var staturBarTheme:ColorScheme {
        switch configuration.colorScheme {
        case .dark:
            return .dark
        case .brown:
            return .light
        default:
            return .light
        }
    }
    
    var body: some View {
        let _ = Self._printChanges()
        
        ZStack {
            NavigationSplitView {
                
                SideBar()
                    .navigationSplitViewColumnWidth(200)
                    .background(theme.themeColor.mainBackground)
                
            } detail: {
                StackContainer()
            }
            .environment(\.isLoading, isLoading)
            
//            .onReceive(configuration.$appLanguage){ lan in
//                
//            }
            .preferredColorScheme(staturBarTheme)
            .onChange(of: configuration.appLanguage) { old, new in
                loadMenu(lan: new.sourceId)
            }
            .onAppear {
                loadMenu(lan: configuration.appLanguage.sourceId)
            }
            
        }
        .overlay(
            showOptions ? OptionGroupListView(model: OptionGroupListView.Model(menu: menuStore.selectMenuItem!),
                                              isShowing: $showOptions, isShowAdd:{
                                                  runAnimation()
                                              }) : nil,
            
            alignment: .center
        )
        .environment(\.goOptions) { menu, image, rect in
            //这里开始触发动画
            animationItemFrame = rect
            selectItem = image
            
            if let optionGroupVoList =  menu.optionGroupVoList,
                optionGroupVoList.count > 0 {
                menuStore.selectMenuItem(menu)
                showOptions.toggle()
            } else {
                //add to shopping car
                soundPlayer.playSound(soundFileName: "14428")
                cargoStore.addGood(menu, price: Int(menu.currentPrice), tableNo: configuration.tableNo ?? "")
                runAnimation()
            }
            
        }
        .overlay {
            if showAddAnimation && selectItem != nil {
                GeometryReader { geometry in
                    let originX = animationItemFrame.midX - geometry.frame(in: .global).minX
                    let originY = animationItemFrame.midY - geometry.frame(in: .global).minY
                    let image = Image(uiImage: selectItem!)
                        .clipShape(Circle())
                        .scaleEffect(carGoAnimation ? 0.1 : 1)
                    
                    image
                        .position(x: originX, y: originY)
                        .offset(x: carGoAnimation ? (menuStore.cartIconGlobalFrame.midX - originX) : 0,
                                y: carGoAnimation ? (menuStore.cartIconGlobalFrame.minY - originY) : 0)
                }
            }
        }
        .environment(\.showError) { error, guidance in
            errorWrapper = ErrorWrapper(error: error, guidance: guidance ?? "")
            isPresentError = true
        }
        .alert(errorWrapper?.error.localizedDescription ?? "Error",
               
               isPresented: $isPresentError, actions: {
            Button("sure_text") {
                isPresentError = false
            }
            .font(configuration.appLanguage.regularFont(14))
        }, message: {
            Text(errorWrapper?.guidance ?? "")
                .font(configuration.appLanguage.regularFont(14))
        })
        .environment(\.showAlert) { title, content in
            alertWrapper = AlertWrapper(title: title, content: content)
            isPresentAlert = true
        }
        .alert(alertWrapper?.title ?? "",
               
               isPresented: $isPresentAlert, actions: {
            Button("sure_text") {
                isPresentAlert = false
            }
            .font(configuration.appLanguage.regularFont(14))
        }, message: {
            Text(alertWrapper?.content ?? "")
                .font(configuration.appLanguage.regularFont(14))
        })
        
//        .onChange(of: configuration.colorScheme) { oldValue, newValue in
//            switch newValue {
//            case .dark:
//                //UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
//                break
//            case .brown:
//                break
//            default:
//                break
//            }
//        }

    }
    
    func loadMenu(lan:String) {
        Task {
            isLoading = true
            guard let shopCode = configuration.shopCode else {
                return
            }
            guard let machineCode = configuration.machineCode else {
                return
            }
            await menuStore.load(shopCode:shopCode, machineCode: machineCode, language:lan)
            isLoading = false
        }
    }
    
    func runAnimation() {
        showAddAnimation = true
        animationManager.enqueue(animation: {
            withAnimation(.easeInOut(duration: 0.3)) {
                carGoAnimation = true
            }
        }, completion: {
            carGoAnimation = false
            showAddAnimation = false
            selectItem = nil
        })
    }
    
}


class AnimationQueueManager: ObservableObject {
    @Published var animationQueue: [AnimationTask] = []
    @Published var isAnimating: Bool = false

    func enqueue(animation: @escaping () -> Void, completion: @escaping () -> Void) {
        animationQueue.append(AnimationTask(action: animation, completion: completion))
        executeNextAnimation()
    }

    private func executeNextAnimation() {
        guard !isAnimating, !animationQueue.isEmpty else { return }
        
        let currentTask = animationQueue.removeFirst()
        isAnimating = true
        currentTask.action()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Adjust based on actual animation time
            currentTask.completion()
            self.isAnimating = false
            self.executeNextAnimation()
        }
    }
}

struct AnimationTask {
    let action: () -> Void
    let completion: () -> Void
}
