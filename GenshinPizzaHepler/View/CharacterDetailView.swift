//
//  CharacterDetailView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/3.
//

import SwiftUI

// @available(iOS 15, *)
struct CharacterDetailView: View {
    // MARK: Internal

    @EnvironmentObject
    var viewModel: ViewModel
    var account: Account
    @State
    var showingCharacterName: String
    var animation: Namespace.ID

    @State
    var showTabViewIndex: Bool = false
    @State
    var showWaterMark: Bool = true

    var playerDetail: PlayerDetail { try! account.playerDetailResult!.get() }
    var avatar: PlayerDetail.Avatar {
        playerDetail.avatars.first(where: { avatar in
            avatar.name == showingCharacterName
        })!
    }

    var body: some View {
        coreBody.environmentObject(orientation)
    }

    @ViewBuilder
    var coreBody: some View {
        if #available(iOS 15.0, *) {
            TabView(selection: $showingCharacterName.animation()) {
                ForEach(playerDetail.avatars, id: \.name) { avatar in
                    framedCoreView(avatar)
                }
            }
            .tabViewStyle(
                .page(
                    indexDisplayMode: showTabViewIndex ? .automatic :
                        .never
                )
            )
            .onTapGesture {
                closeView()
            }
            .background(
                EnkaWebIcon(iconString: avatar.namecardIconString)
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                    .overlay(.thinMaterial)
            )
            .hiddenWaterMark()
            .overlay(alignment: .topTrailing) {
                if ThisDevice.notchType == .none, showWaterMark {
                    Image("AppIconHD")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(maxHeight: 20)
                        .padding()
                }
            }
            .onChange(of: showingCharacterName) { _ in
                simpleTaptic(type: .selection)
                withAnimation(.easeIn(duration: 0.1)) {
                    showTabViewIndex = true
                    showWaterMark = false
                }
            }
            .ignoresSafeArea()
            .statusBarHidden(true)
            .onAppear {
                showTabViewIndex = true
                showWaterMark = false
            }
            .onChange(of: showTabViewIndex) { newValue in
                if newValue == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        withAnimation {
                            showTabViewIndex = false
                        }
                    }
                }
            }
            .onChange(of: showWaterMark) { newValue in
                if newValue == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        withAnimation(.easeIn(duration: 0.1)) {
                            showWaterMark = true
                        }
                    }
                }
            }
        } else {
            // Fallback on earlier versions
            TabView(selection: $showingCharacterName) {
                ForEach(playerDetail.avatars, id: \.name) { avatar in
                    framedCoreView(avatar)
                }
            }
            .tabViewStyle(
                .page(
                    indexDisplayMode: showTabViewIndex ? .automatic :
                        .never
                )
            )
            .onTapGesture {
                closeView()
            }
            .background(
                EnkaWebIcon(iconString: avatar.namecardIconString)
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                    .blur(radius: 30)
            )
            .onChange(of: showingCharacterName) { _ in
                simpleTaptic(type: .selection)
                withAnimation(.easeIn(duration: 0.1)) {
                    showTabViewIndex = true
                    showWaterMark = false
                }
            }
            .ignoresSafeArea()
            .statusBarHidden(true)
            .onAppear {
                showTabViewIndex = true
                showWaterMark = false
            }
            .onChange(of: showTabViewIndex) { newValue in
                if newValue == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        withAnimation {
                            showTabViewIndex = false
                        }
                    }
                }
            }
            .onChange(of: showWaterMark) { newValue in
                if newValue == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        withAnimation(.easeIn(duration: 0.1)) {
                            showWaterMark = true
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    func framedCoreView(
        _ avatar: PlayerDetail
            .Avatar
    )
        -> some View {
        VStack {
            Spacer().frame(width: 25, height: 10)
            EachCharacterDetailDataView(
                avatar: avatar,
                animation: animation
            ).frame(minWidth: 620, maxWidth: 830) // For iPad
                .frame(width: condenseHorizontally ? 620 : nil)
                .fixedSize(
                    horizontal: condenseHorizontally,
                    vertical: true
                )
                .scaleEffect(scaleRatioCompatible)
            Spacer().frame(width: 25, height: 20)
        }
    }

    func closeView() {
        simpleTaptic(type: .light)
        withAnimation(.interactiveSpring(
            response: 0.25,
            dampingFraction: 1.0,
            blendDuration: 0
        )) {
            viewModel.showCharacterDetailOfAccount = nil
            viewModel.showingCharacterName = nil
        }
    }

    // MARK: Private

    @StateObject
    private var orientation = ThisDevice.DeviceOrientation()

    private var scaleRatioCompatible: CGFloat {
        ThisDevice.scaleRatioCompatible
    }

    private var condenseHorizontally: Bool {
        guard ThisDevice.idiom != .phone else { return true }
        guard ThisDevice.useAdaptiveSpacing else { return true }
        // iPad and macOS.
        return ThisDevice.isSplitOrSlideOver && orientation
            .orientation == .portrait && ThisDevice.idiom != .phone
    }
}
