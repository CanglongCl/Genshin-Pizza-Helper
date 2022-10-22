//
//  CharacterDetailView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/3.
//

import SwiftUI

//@available(iOS 15, *)
struct CharacterDetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    var account: Account
    var playerDetail: PlayerDetail { try! account.playerDetailResult!.get() }
    @State var showingCharacterName: String
    var avatar: PlayerDetail.Avatar {
        playerDetail.avatars.first(where: { avatar in
            avatar.name == showingCharacterName
        })!
    }

    var animation: Namespace.ID

    @State var showTabViewIndex: Bool = false
    @State var showWaterMark: Bool = true

    var body: some View {
        if #available(iOS 15.0, *) {
            TabView(selection: $showingCharacterName) {
                ForEach(playerDetail.avatars, id: \.name) { avatar in
                    EachCharacterDetailDatasView(avatar: avatar, animation: animation)
                        .frame(maxWidth: 500) // For iPad
                }
            }
            .tabViewStyle(.page(indexDisplayMode: showTabViewIndex ? .automatic : .never))
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
                if ThisDevice.notchType == .none && showWaterMark {
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
                    EachCharacterDetailDatasView(avatar: avatar, animation: animation)
                        .frame(maxWidth: 500) // For iPad
                }
            }
            .tabViewStyle(.page(indexDisplayMode: showTabViewIndex ? .automatic : .never))
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

    func closeView() {
        simpleTaptic(type: .light)
        withAnimation(.interactiveSpring(response: 0.25, dampingFraction: 1.0, blendDuration: 0)) {
            viewModel.showCharacterDetailOfAccount = nil
            viewModel.showingCharacterName = nil
        }
    }
}
