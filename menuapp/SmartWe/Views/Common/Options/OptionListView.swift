//
//  OptionListView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/13.
//

import SwiftUI



struct OptionListView: View {
    
    let option:OptionGroup
    
    
    var body: some View {
        
        VStack(alignment: .leading, content: {
            Text(option.groupName)
                .font(CustomFonts.optionTitle2Font)
            let columns: [GridItem] = [.init(.adaptive(minimum: 120))]
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(option.optionVoList) { optionVo in
                    OptionButton(optionVo: optionVo)
                }
            }
        })
    }
}

#Preview {
    OptionListView(option: sampleOptionGroups[0])
}

let sampleOptionVos: [OptionVo] = [
    OptionVo(bounds: 1, boundsPrice: 5.0, buttonColorValue: "0xFF0000", currentPrice: 4.5, group: "1", groupName: "饮料", homeImage: "drink_image", homeImageHttp: "http://example.com/drink_image", mainTitle: "可乐", optionCode: "cola", price: 5.0, printText: "冰镇可乐", standard: 1, subTitle: ["冰爽"]),
    OptionVo(bounds: 1, boundsPrice: 5.0, buttonColorValue: "0xFF0000", currentPrice: 4.5, group: "1", groupName: "饮料", homeImage: "drink_image", homeImageHttp: "http://example.com/drink_image", mainTitle: "可乐", optionCode: "cola", price: 5.0, printText: "雪碧", standard: 1, subTitle: ["冰爽"]),
    OptionVo(bounds: 2, boundsPrice: 10.0, buttonColorValue: "0x00FF00", currentPrice: 9.0, group: "2", groupName: "小吃", homeImage: "snack_image", homeImageHttp: "http://example.com/snack_image", mainTitle: "薯条", optionCode: "fries", price: 10.0, printText: "脆薯条", standard: 1, subTitle: ["金黄"]),
    OptionVo(bounds: 2, boundsPrice: 10.0, buttonColorValue: "0x00FF00", currentPrice: 9.0, group: "2", groupName: "小吃", homeImage: "snack_image", homeImageHttp: "http://example.com/snack_image", mainTitle: "鸡块", optionCode: "fries", price: 10.0, printText: "炸鸡块", standard: 1, subTitle: ["金黄"])
]

let sampleOptionGroups: [OptionGroup] = [
    OptionGroup(groupCode: "1", groupName: "饮料类", multipleState: "0", optionVoList:sampleOptionVos, printText: "选择一种饮料", remark: "冷饮", smallest: "1"),
    OptionGroup(groupCode: "2", groupName: "小吃类", multipleState: "1", optionVoList: sampleOptionVos, printText: "选择一种小吃", remark: "热食", smallest: "1")
]
