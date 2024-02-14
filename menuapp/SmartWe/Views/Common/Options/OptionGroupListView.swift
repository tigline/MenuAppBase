//
//  OptionGroupListView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/13.
//

import SwiftUI
import NukeUI

struct OptionGroupListView: View {
    let optionGroups:[OptionGroup]
    
    var body: some View {
        HStack(alignment:.top, content:  {
            //image area
            VStack(spacing: 10, content: {
                LazyImage(url: URL(string: ""))
                HStack(spacing: 10, content: {
                    LazyImage(url: URL(string: ""))
                        .frame(height: 150)
                    LazyImage(url: URL(string: ""))
                        .frame(height: 150)
                })
            }).frame(width: 300, height: 560)
            //option area
            
            VStack(alignment: .leading, spacing: 20, content: {
                
                Text("フルーツミックスミルクティー")
                    .font(.title)
                Text("マンゴー、ライチ、オレンジのフレッシュフルーツを加えたおいしいお")
                    .font(.subheadline)
                
                ForEach(optionGroups) { optionGroup in
                    OptionListView(option: optionGroup)
                }
            })
                
    

        }).padding()
    }
}

#Preview {
    OptionGroupListView(optionGroups: sampleOptionGroups)
}
