//
//  SwiftUIView.swift
//  SmartWe
//
//  Created by Aaron on 2024/2/19.
//

import SwiftUI



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
            ZStack {
                // 设置渐变或图像背景
                LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                List(TestCategory.allCases, id: \.self) { category in
                    NavigationLink(value: category) {
                        Text(category.localizedName)
                    }
                    .listRowBackground(Color.clear) // 为每行设置透明背景
                }
                .background(.pink)
                .scrollContentBackground(.hidden)// 确保 List 背景透明
            }
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
