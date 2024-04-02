//
//  SwiftUIView.swift
//  SmartWe
//
//  Created by Aaron on 2024/2/19.
//

import SwiftUI

import SwiftUI

struct ContentView1: View {
    let items = Array(1...30)
    @State private var selectedItem: Int? = nil
    @State private var showDetailView = false
    @State private var animationStartFrame: CGRect = .zero

    var body: some View {
        ZStack {
            // 背景变灰，当弹出详情视图时
            if showDetailView {
                Color.gray.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showDetailView = false
                        }
                    }
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(items, id: \.self) { item in
                        Text("Item \(item)")
                            .frame(height: 100)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding()
                            .onTapGesture {
                                selectedItem = item
                                withAnimation {
                                    showDetailView = true
                                }
                            }
                            // 使用 GeometryReader 来获取当前 item 的 frame
                            .background(GeometryReader { geometry -> Color in
                                if selectedItem == item && showDetailView {
                                    animationStartFrame = geometry.frame(in: .global)
                                }
                                return Color.clear
                            })
                    }
                }
            }

            // 弹出的详情视图
            if showDetailView, let selectedItem = selectedItem {
                DetailView1(item: selectedItem)
                    .frame(width: 200, height: 200)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .position(x: animationStartFrame.midX, y: animationStartFrame.midY)
                    .scaleEffect(showDetailView ? 1 : 0)
                    .offset(y: showDetailView ? UIScreen.main.bounds.midY - animationStartFrame.midY : 0)
                    .animation(.spring(), value: showDetailView)
            }
        }
    }
}

struct DetailView1: View {
    let item: Int

    var body: some View {
        VStack {
            Text("Detail for item \(item)")
        }
    }
}




// 假设有一个简单的类别枚举
enum TestCategory: String, CaseIterable, Identifiable {
    case books = "Books"
    case music = "Music"
    case games = "Games"
    
    var id: Self { self }
    var localizedName: String { self.rawValue }
}

struct SwiftUIAView: View {
    var body: some View {
        NavigationStack {
      
                
                List(TestCategory.allCases, id: \.self) { category in
                    NavigationLink(value: category) {
                        Text(category.localizedName)
                    }
                    .listRowBackground(Color.clear) // 为每行设置透明背景
                }
                .background{
                    LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                }
                .scrollContentBackground(.hidden)// 确保 List 背景透明
       
            .navigationDestination(for: TestCategory.self) { category in
                // 根据类别展示不同的视图
                DetailView(category: category)
            }
        }
    }
}

struct DetailView: View {
    let category: TestCategory
    
    var body: some View {
        Text("显示 \(category.localizedName) 的详细信息")
    }
}


#Preview {
    SwiftUIAView()
}
