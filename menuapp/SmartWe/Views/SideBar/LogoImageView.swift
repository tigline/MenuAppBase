//
//  LogoImageView.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/08.
//

import SwiftUI
import NukeUI

struct LogoImageView: View {
    let path:String
    @Environment(\.imagePipeline) private var imagePipeline
    @State private var scale: CGFloat = 1
    var body: some View {
        if let url = URL(string: path) {
            LazyImage(url: url) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaleEffect(scale)
                        .animation(.default, value: scale)
                } else {
                    DownloadPlaceHolder()
                }
            }
            .pipeline(imagePipeline)
        } else {
            DownloadPlaceHolder()
        }
    }
    
}

#Preview {
    LogoImageView(path: "http://image-sit.smartwe.co.jp/JGGX6NQZ/U7PtpqQluemBKQuEFl0uv.bmp?Policy=eyJTdGF0ZW1lbnQiOiBbeyJSZXNvdXJjZSI6Imh0dHA6Ly9pbWFnZS1zaXQuc21hcnR3ZS5jby5qcC8qIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzA4MTgyMDAwfSwiSXBBZGRyZXNzIjp7IkFXUzpTb3VyY2VJcCI6IjAuMC4wLjAvMCJ9LCJEYXRlR3JlYXRlclRoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTcwNzIzMTYwMH19fV19&Signature=EVsM3dk848Wq2LX0PsWihMwOR04iawvQ~Tolv8T1~O6c9jxentulrxMyLpjs2JNe8hjApfpzdItnizOZQAEEUkj~5g6u6lIAmRx19wk6F-vSHta2ypjwFRBU001wdwyWDyRFienKfveB7RXy~bnXwgtA7j1~fn1-678uxYXDSw4gICpWzHcBWGJBCMoIMIkciR65ry1UCpmeBYV3ufQ1SPnYTBLwvRnIYqM7AtHW~GDTtSWOUAMSSaGdNgDijJcZeXj44i496TXn0c69RvFU6Z~4TM8VhGSb8emHKx5CpOYYkqHyk6ZUOl4mpyE3hJp17h8ahp~1jE539-EPK83PWA__&Key-Pair-Id=APKAQCBDBFIFSPBGSDVC")
}
