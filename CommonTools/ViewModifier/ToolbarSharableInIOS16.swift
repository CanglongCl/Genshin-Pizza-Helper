//
//  ToolbarSharableInIOS16.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/13.
//

import SwiftUI

extension View {
    func toolbarSavePhotoButtonInIOS16<ViewToRender: View>(
        title: String = "保存".localized,
        placement: ToolbarItemPlacement = .navigationBarTrailing,
        viewToShare: @escaping () -> ViewToRender
    )
        -> some View {
        modifier(ToolbarSavePhotoButton(
            viewToRender: viewToShare,
            placement: placement,
            title: title
        ))
    }
}

// MARK: - ToolbarSavePhotoButton

struct ToolbarSavePhotoButton<ViewToRender: View>: ViewModifier {
    // MARK: Lifecycle

    init(
        @ViewBuilder viewToRender: @escaping () -> ViewToRender,
        placement: ToolbarItemPlacement = .navigationBarTrailing,
        title: String
    ) {
        self.viewToRender = viewToRender()
        self.placement = placement
        self.title = title
    }

    // MARK: Internal

    var viewToRender: ViewToRender

    let placement: ToolbarItemPlacement
    let title: String

    @State
    var isAlertShow: Bool = false

    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
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
                        let renderer = ImageRenderer(
                            content: viewToRender
                                .environment(
                                    \.locale,
                                    .init(identifier: Locale.current.identifier)
                                )
                        )
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
