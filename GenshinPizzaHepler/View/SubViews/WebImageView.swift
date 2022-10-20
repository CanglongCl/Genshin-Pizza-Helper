//
//  WebImageView.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/8/12.
//  封装了iOS 14与iOS 15中两种方法的异步加载网络图片的View

import SwiftUI

struct WebImage: View {
    var urlStr: String

    @State private var imageData: UIImage? = nil

    var body: some View {
        if #available(iOS 15.0, watchOS 8.0, *) {
            AsyncImage(
                        url: URL(string: urlStr),
                        transaction: Transaction(animation: .default)
                    ) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        default:
                            ProgressView()
                        }
                    }
        } else {
            // Fallback on earlier versions
            if imageData == nil {
                ProgressView()
                    .onAppear {
                        let url = URL(string: urlStr)
                        if url != nil {
                            DispatchQueue.global(qos: .background).async {
                                let data = try? Data(contentsOf: url!)
                                guard data != nil else {
                                    return
                                }
                                imageData = UIImage(data: data!)
                            }
                        }
                    }
            } else {
                Image(uiImage: imageData!)
                    .resizable().aspectRatio(contentMode: .fit)
            }
        }
    }
}

struct NetworkImage: View {
    let url: URL?
    
    var body: some View {
        Group {
            if let url = url, let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                //         .aspectRatio(contentMode: .fill)
            }
            else {
                Image("placeholder-image")
            }
        }
    }
}

struct EnkaWebIcon: View {
    var iconString: String

    var body: some View {
        if let image = UIImage(named: iconString) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            WebImage(urlStr: "https://enka.network/ui/\(iconString).png")
        }
    }
}

struct HomeSourceWebIcon: View {
    var iconString: String

    var body: some View {
        if let image = UIImage(named: iconString) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            WebImage(urlStr: "http://ophelper.top/resource/\(iconString).png")
        }
    }
}

