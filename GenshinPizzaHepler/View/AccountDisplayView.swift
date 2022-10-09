//
//  AccountDisplayView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/8/22.
//  弹出的展示帐号详细信息的View

import SwiftUI

struct AccountDisplayView: View {
    @EnvironmentObject var viewModel: ViewModel
    var account: Account
    var animation: Namespace.ID
    var accountName: String { account.config.name! }
    var accountUUIDString: String { account.config.uuid!.uuidString }
    var userData: UserData { switch account.result {
    case .success(let userData):
        return userData
    default:
        return .defaultData
    }}
    var basicAccountInfo: BasicInfos? { account.basicInfo }

    @State private var animationDone: Bool = false
    @State var scrollOffset: CGPoint = .zero
    @State var isAccountInfoShow: Bool = false

    @State var isStatusBarHide: Bool = false
    @State var fadeOutAnimation: Bool = true
    @State var isExpeditionsAppeared: Bool = false
    @State var isAnimationLocked: Bool = false

    var body: some View {
        GeometryReader { geo in
            ScrollView (showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer(minLength: 80)
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                    Image(systemName: "person.fill")
                                    Text(accountName)
                                }
                                .font(.footnote)
                                .foregroundColor(Color("textColor3"))
                                .matchedGeometryEffect(id: "\(accountUUIDString)name", in: animation)
                                HStack(alignment: .firstTextBaseline, spacing: 2) {

                                    Text("\(userData.resinInfo.currentResin)")
                                        .font(.system(size: 50 , design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("textColor3"))
                                        .shadow(radius: 1)
                                        .matchedGeometryEffect(id: "\(accountUUIDString)curResin", in: animation)
                                    Image("树脂")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 30)
                                        .alignmentGuide(.firstTextBaseline) { context in
                                            context[.bottom] - 0.17 * context.height
                                        }
                                        .matchedGeometryEffect(id: "\(accountUUIDString)Resinlogo", in: animation)
                                }
                                HStack {
                                    Image(systemName: "hourglass.circle")
                                        .foregroundColor(Color("textColor3"))
                                        .font(.title3)
                                    recoveryTimeText(resinInfo: userData.resinInfo)
                                }
                                .matchedGeometryEffect(id: "\(accountUUIDString)recovery", in: animation)
                            }
                            .padding(.horizontal)
                            DetailInfo(userData: userData, viewConfig: .defaultConfig)
                                .padding(.horizontal)
                                .matchedGeometryEffect(id: "\(accountUUIDString)detail", in: animation)
                        }
                        expeditionsView()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    isExpeditionsAppeared = true
                                }
                            }
                    }
                    Spacer()
                    if !isAccountInfoShow {
                        HStack {
                            Spacer()
                            Text("上滑查看更多基本信息")
                                .font(.footnote)
                                .opacity(fadeOutAnimation ? 0 : 1)
                                .offset(y: fadeOutAnimation ? 15 : 0)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation {
                                            fadeOutAnimation.toggle()
                                        }
                                    }
                                }
                                .onChange(of: fadeOutAnimation) { _ in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        withAnimation {
                                            fadeOutAnimation.toggle()
                                        }
                                    }
                                }
                            Spacer()
                        }
                    }
                }
                .shouldTakeAllVerticalSpace(!isAccountInfoShow, height: geo.size.height, animation: animation)
                .readingScrollView(from: "scroll", into: $scrollOffset)
                if isAccountInfoShow {
                    Spacer(minLength: 40)
                    VStack(alignment: .leading) {
                        HStack(alignment: .lastTextBaseline, spacing: 5) {
                            Image(systemName: "person.fill")
                            Text("\(accountName) (\(account.config.uid ?? ""))")
                        }
                        .font(.headline)
                        .foregroundColor(Color("textColor3"))
                        AccountBasicInfosView(basicAccountInfo: basicAccountInfo)
                    }
                    .animation(.easeInOut)
                }
            }
            .padding(.horizontal, 25)
            .coordinateSpace(name: "scroll")
            .onChange(of: scrollOffset) { new in
                print("Offset: \(scrollOffset.y)")
                if scrollOffset.y > 20 && !isAccountInfoShow && !isAnimationLocked {
                    simpleTaptic(type: .medium)
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                        isAccountInfoShow = true
                        isStatusBarHide = true
                        isAnimationLocked = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                            isAnimationLocked = false
                        }
                    }
                }
                else if scrollOffset.y < -20 && isAccountInfoShow && !isAnimationLocked {
                    simpleTaptic(type: .medium)
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                        isAccountInfoShow = false
                        isStatusBarHide = false
                        isAnimationLocked = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                            isAnimationLocked = false
                        }
                    }
                }
            }
        }
        .background(
            AppBlockBackgroundView(background: account.background, darkModeOn: true)
                .matchedGeometryEffect(id: "\(accountUUIDString)bg", in: animation)
                .padding(-10)
                .ignoresSafeArea(.all)
                .blurMaterial(),
            alignment: .trailing
        )
        .onTapGesture {
            closeView()
        }
        .statusBarHidden(isStatusBarHide)
    }

    private func closeView() -> Void {
        DispatchQueue.main.async {
            // 复位更多信息展示页面
            isAccountInfoShow = false
            isStatusBarHide = false
            scrollOffset = .zero
        }
        withAnimation(.interactiveSpring(response: 0.25, dampingFraction: 1.0, blendDuration: 0)) {
            simpleTaptic(type: .light)
            viewModel.showDetailOfAccount = nil
        }
    }

    @ViewBuilder
    func expeditionsView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(userData.expeditionInfo.expeditions, id: \.charactersEnglishName) { expedition in
                InAppEachExpeditionView(expedition: expedition, useAsyncImage: true, animatedMe: !isExpeditionsAppeared)
            }
        }
    }

    @ViewBuilder
    func recoveryTimeText(resinInfo: ResinInfo) -> some View {
        if resinInfo.recoveryTime.second != 0 {
            Text(LocalizedStringKey("\(resinInfo.recoveryTime.describeIntervalLong())\n\(resinInfo.recoveryTime.completeTimePointFromNow()) 回满"))
                .font(.caption)
                .lineLimit(2)
                .minimumScaleFactor(0.2)
                .foregroundColor(Color("textColor3"))
                .lineSpacing(1)
                .fixedSize()
        } else {
            Text("0小时0分钟\n树脂已全部回满")
                .font(.caption)
                .lineLimit(2)
                .minimumScaleFactor(0.2)
                .foregroundColor(Color("textColor3"))
                .lineSpacing(1)
                .fixedSize()
        }
    }

}

struct GameInfoBlockForSave: View {
    var userData: UserData
    let accountName: String
    var accountUUIDString: String = UUID().uuidString

    let viewConfig = WidgetViewConfiguration.defaultConfig
    var animation: Namespace.ID

    var widgetBackground: WidgetBackground
    @State var bgFadeOutAnimation: Bool = false

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                if let accountName = accountName {
                    HStack(alignment: .lastTextBaseline, spacing: 2) {
                        Image(systemName: "person.fill")
                        Text(accountName)
                    }
                    .font(.footnote)
                    .foregroundColor(Color("textColor3"))
                }
                HStack(alignment: .firstTextBaseline, spacing: 2) {

                    Text("\(userData.resinInfo.currentResin)")
                        .font(.system(size: 50 , design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(Color("textColor3"))
                        .shadow(radius: 1)
                    Image("树脂")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 30)
                        .alignmentGuide(.firstTextBaseline) { context in
                            context[.bottom] - 0.17 * context.height
                        }
                }
                HStack {
                    Image(systemName: "hourglass.circle")
                        .foregroundColor(Color("textColor3"))
                        .font(.title3)
                    RecoveryTimeText(resinInfo: userData.resinInfo)
                }
            }
            .padding()
            Spacer()
            DetailInfo(userData: userData, viewConfig: .defaultConfig)
                .padding(.vertical)
                .frame(maxWidth: UIScreen.main.bounds.width / 8 * 3)
            Spacer()
        }
        .background(AppBlockBackgroundView(background: widgetBackground, darkModeOn: true))
    }
}

extension View {
    func blurMaterial() -> some View {
        if #available(iOS 15.0, *) {
            return AnyView(self.overlay(.ultraThinMaterial).preferredColorScheme(.dark))
        } else {
            return AnyView(self.blur(radius: 10))
        }
    }
    
    func shouldTakeAllVerticalSpace(_ shouldTake: Bool, height: CGFloat, animation: Namespace.ID) -> some View {
        Group {
            if shouldTake {
                self
                    .matchedGeometryEffect(id: "account resin infos", in: animation)
                    .frame(height: height)
            } else {
                self
                    .matchedGeometryEffect(id: "account resin infos", in: animation)
            }
        }
    }
}

private struct InAppEachExpeditionView: View {
    let expedition: Expedition
    let viewConfig: WidgetViewConfiguration = .defaultConfig
    var useAsyncImage: Bool = false
    var animationDelay: Double = 0
    let animatedMe: Bool

    @State var percentage: Double = 0.0

    var body: some View {
        HStack {
            webView(url: expedition.avatarSideIconUrl)
            VStack(alignment: .leading) {
                Text(expedition.recoveryTime.describeIntervalLong(finishedTextPlaceholder: "已完成".localized))
                    .lineLimit(1)
                    .font(.footnote)
                    .minimumScaleFactor(0.4)
                percentageBar(percentage)
                    .environment(\.colorScheme, .light)
            }
        }
        .foregroundColor(Color("textColor3"))
        .onAppear {
            if animatedMe {
                withAnimation(.interactiveSpring(response: pow(expedition.percentage, 1/2)*0.8, dampingFraction: 1, blendDuration: 0).delay(animationDelay)) {
                    percentage = expedition.percentage
                }
            } else {
                percentage = expedition.percentage
            }
        }

//        webView(url: expedition.avatarSideIconUrl)
//            .border(.black, width: 3)
//        .frame(maxWidth: UIScreen.main.bounds.width / 8 * 3)
//        .background(WidgetBackgroundView(background: .randomNamecardBackground, darkModeOn: true))
    }

    @ViewBuilder
    func webView(url: URL) -> some View {
        GeometryReader { g in
            if useAsyncImage {
                WebImage(urlStr: expedition.avatarSideIcon)
                    .scaleEffect(1.5)
                    .scaledToFit()
                    .offset(x: -g.size.width * 0.06, y: -g.size.height * 0.25)
            } else {
                NetworkImage(url: expedition.avatarSideIconUrl)
                    .scaleEffect(1.5)
                    .scaledToFit()
                    .offset(x: -g.size.width * 0.06, y: -g.size.height * 0.25)
            }
        }
        .frame(maxWidth: 50, maxHeight: 50)
    }

    @ViewBuilder
    func percentageBar(_ percentage: Double) -> some View {

        let cornerRadius: CGFloat = 3
        if #available(iOS 15.0, iOSApplicationExtension 15.0, *) {
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .frame(width: g.size.width, height: g.size.height)
                        .foregroundStyle(.ultraThinMaterial)
                        .opacity(0.6)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .frame(width: g.size.width * percentage, height: g.size.height)
                        .foregroundStyle(.thickMaterial)
                }
                .aspectRatio(30/1, contentMode: .fit)
//                .preferredColorScheme(.light)
            }
            .frame(height: 7)
        } else {
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .opacity(0.3)
                        .frame(width: g.size.width, height: g.size.height)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .frame(width: g.size.width * percentage, height: g.size.height)
                }
                .aspectRatio(30/1, contentMode: .fit)
            }
            .frame(height: 7)
        }
    }
}
