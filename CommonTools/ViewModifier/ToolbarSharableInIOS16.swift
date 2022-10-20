//
//  ToolbarSharableInIOS16.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/13.
//

import SwiftUI

@available(iOS 15, *)
extension View {
    func toolbarSavePhotoButtonInIOS16<ViewToRender: View>(viewToShare: @escaping () -> ViewToRender, placement: ToolbarItemPlacement = .navigationBarTrailing, title: String = "保存") -> some View {
        modifier(ToolbarSavePhotoButton(viewToRender: viewToShare, placement: placement, title: title))
    }
}

@available(iOS 15, *)
struct ToolbarSavePhotoButton<ViewToRender: View>: ViewModifier {

    var viewToRender: ViewToRender

    let placement: ToolbarItemPlacement
    let title: String

    @State var isAlertShow: Bool = false

    init(@ViewBuilder viewToRender: @escaping () -> ViewToRender,
         placement: ToolbarItemPlacement = .navigationBarTrailing,
         title: String) {
        self.viewToRender = viewToRender()
        self.placement = placement
        self.title = title
    }

//    @MainActor @available(iOS 16.0, *)
//    func generateSharePhoto() -> UIImage? {
//        let renderer = ImageRenderer(content: viewToRender)
//        renderer.scale = UIScreen.main.scale
//        return renderer.uiImage
//    }

    func body(content: Content) -> some View {
        if #available(iOS 16, *)
//            , let image = generateSharePhoto()
        {
            content
                .toolbar {
                    ToolbarItem(placement: placement) {
//                        ShareLink(
//                            item: Image(uiImage: image),
//                            preview: SharePreview("分享", image: Image(uiImage: image))
//                        )
                        Button {
                            isAlertShow = true
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                }
                .alert(title, isPresented: $isAlertShow) {
                    Button("OK") {
                        let renderer = ImageRenderer(content: viewToRender)
                        renderer.scale = UIScreen.main.scale
                        if let image = renderer.uiImage {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                    }
                    Button("取消", role: .cancel) {}
                }
        } else {
            content
        }
    }
}
