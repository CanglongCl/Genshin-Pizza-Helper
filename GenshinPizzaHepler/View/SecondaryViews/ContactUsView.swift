//
//  ContactUsView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/8/29.
//  联系我们View

import SwiftUI

// MARK: - ContactUsView

struct ContactUsView: View {
    // MARK: Internal

    var groupFooterText: String {
        var text = ""
        if Locale.isUILanguagePanChinese {
            text = "我们推荐您加入QQ频道。QQ群都即将满员，而在频道你可以与更多朋友们交流，第一时间获取来自开发者的消息，同时还有官方消息的转发和其他更多功能！"
        }
        return text
    }

    var body: some View {
        List {
            // developer - lava
            Section(header: Text("开发者")) {
                HStack {
                    Image("avatar.lava")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        Text("Lava")
                            .bold()
                            .padding(.vertical, 5)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isLavaDetailShow ? 90 : 0))
                }
                .onTapGesture {
                    simpleTaptic(type: .light)
                    withAnimation {
                        isLavaDetailShow.toggle()
                    }
                }
                if isLavaDetailShow {
                    Link(
                        destination: URL(
                            string: "mailto:daicanglong@gmail.com"
                        )!
                    ) {
                        Label {
                            Text("daicanglong@gmail.com")
                        } icon: {
                            Image("email")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(
                        destination: URL(
                            string: "https://space.bilibili.com/13079935"
                        )!
                    ) {
                        Label {
                            Text("Bilibili主页")
                        } icon: {
                            Image("bilibili")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(
                        destination: URL(
                            string: "https://github.com/CanglongCl"
                        )!
                    ) {
                        Label {
                            Text("GitHub主页")
                        } icon: {
                            Image("github")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
            }
            // developer - hakubill
            Section {
                HStack {
                    Image("avatar.hakubill")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        Text("水里的碳酸钙")
                            .bold()
                            .padding(.vertical, 5)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isHakubillDetailShow ? 90 : 0))
                }
                .onTapGesture {
                    simpleTaptic(type: .light)
                    withAnimation {
                        isHakubillDetailShow.toggle()
                    }
                }
                if isHakubillDetailShow {
                    Link(destination: URL(string: "https://hakubill.tech")!) {
                        Label {
                            Text("个人主页")
                        } icon: {
                            Image("homepage")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(destination: URL(string: "mailto:i@hakubill.tech")!) {
                        Label {
                            Text("i@hakubill.tech")
                        } icon: {
                            Image("email")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(
                        destination: isInstallation(urlString: "twitter://") ?
                            URL(
                                string: "twitter://user?id=890517369637847040"
                            )! :
                            URL(string: "https://twitter.com/Haku_Bill")!
                    ) {
                        Label {
                            Text("Twitter主页")
                        } icon: {
                            Image("twitter")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(
                        destination: URL(
                            string: "https://www.youtube.com/channel/UC0ABPKMmJa2hd5nNKh5HGqw"
                        )!
                    ) {
                        Label {
                            Text("YouTube频道")
                        } icon: {
                            Image("youtube")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(
                        destination: URL(
                            string: "https://space.bilibili.com/158463764"
                        )!
                    ) {
                        Label {
                            Text("Bilibili主页")
                        } icon: {
                            Image("bilibili")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(
                        destination: URL(
                            string: "https://github.com/Bill-Haku"
                        )!
                    ) {
                        Label {
                            Text("GitHub主页")
                        } icon: {
                            Image("github")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
            }
            // developer - ShikiSuen
            Section {
                HStack {
                    Image("avatar.shikisuen")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        Text("Shiki Suen (孙志贵)")
                            .bold()
                            .padding(.vertical, 5)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isShikiDetailShow ? 90 : 0))
                }
                .onTapGesture {
                    simpleTaptic(type: .light)
                    withAnimation {
                        isShikiDetailShow.toggle()
                    }
                }
                if isShikiDetailShow {
                    Link(
                        destination: URL(string: "https://shikisuen.gitee.io/")!
                    ) {
                        Label {
                            Text("个人主页")
                        } icon: {
                            Image("homepage")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(destination: URL(string: "mailto:shikisuen@pm.me")!) {
                        Label {
                            Text("shikisuen@pm.me")
                        } icon: {
                            Image("email")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(
                        destination: isInstallation(urlString: "twitter://") ?
                            URL(
                                string: "twitter://user?id=176288731"
                            )! :
                            URL(string: "https://twitter.com/ShikiSuen")!
                    ) {
                        Label {
                            Text("Twitter主页")
                        } icon: {
                            Image("twitter")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(
                        destination: URL(
                            string: "https://space.bilibili.com/911304"
                        )!
                    ) {
                        Label {
                            Text("Bilibili主页")
                        } icon: {
                            Image("bilibili")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(
                        destination: URL(
                            string: "https://github.com/ShikiSuen"
                        )!
                    ) {
                        Label {
                            Text("GitHub主页")
                        } icon: {
                            Image("github")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
            }

//            Section {
//                Link(destination: URL(string: "https://ophelper.top")!) {
//                    Text("原神披萨小助手官方网站")
            ////                }
//                Link(destination: URL(string: "https://abyss.ophelper.top")!) {
//                    Text("原神披萨深渊榜网页版")
//                }
//            }

            // app contact
            Section(
                header: Text("用户交流群"),
                footer: Text(groupFooterText).textCase(.none)
            ) {
                Menu {
                    Link(
                        destination: URL(
                            string: "https://pd.qq.com/s/9z504ipbc"
                        )!
                    ) {
                        Label {
                            Text("加入QQ频道")
                        } icon: {
                            Image("qq.circle")
                                .resizable()
                                .scaledToFit()
                        }
                    }

                    Link(
                        destination: URL(
                            string: "mqqapi://card/show_pslcard?src_type=internal&version=1&card_type=group&uin=813912474"
                        )!
                    ) {
                        Label {
                            Text("1群: 813912474")
                        } icon: {
                            Image("qq")
                                .resizable()
                                .scaledToFit()
                        }
                    }

                    Link(
                        destination: URL(
                            string: "mqqapi://card/show_pslcard?src_type=internal&version=1&card_type=group&uin=829996515"
                        )!
                    ) {
                        Label {
                            Text("2群: 829996515")
                        } icon: {
                            Image("qq")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                } label: {
                    Label {
                        Text("加入QQ群")
                    } icon: {
                        Image("qq")
                            .resizable()
                            .scaledToFit()
                    }
                }

                Link(
                    destination: URL(string: "https://discord.gg/g8nCgKsaMe")!
                ) {
                    Label {
                        Text("加入Discord服务器")
                    } icon: {
                        Image("discord")
                            .resizable()
                            .scaledToFit()
                    }
                }

                if Bundle.main.preferredLocalizations.first != "ja" {
                    Menu {
                        Link(
                            destination: URL(
                                string: "https://t.me/ophelper_zh"
                            )!
                        ) {
                            Label {
                                Text("中文频道")
                            } icon: {
                                Image("telegram")
                                    .resizable()
                                    .scaledToFit()
                            }
                        }

                        Link(
                            destination: URL(
                                string: "https://t.me/ophelper_en"
                            )!
                        ) {
                            Label {
                                Text("English Channel")
                            } icon: {
                                Image("telegram")
                                    .resizable()
                                    .scaledToFit()
                            }
                        }

                        Link(
                            destination: URL(
                                string: "https://t.me/ophelper_ru"
                            )!
                        ) {
                            Label {
                                Text("русскоязычный канал")
                            } icon: {
                                Image("telegram")
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    } label: {
                        Label {
                            Text("加入Telegram频道")
                        } icon: {
                            Image("telegram")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
            }

            // special thanks
            Section(header: Text("翻译提供")) {
                Label {
                    HStack {
                        Text("Lava")
                        Spacer()
                        Text("英文")
                            .foregroundColor(.gray)
                    }
                } icon: {
                    Image("avatar.lava")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                }
                Label {
                    HStack {
                        Text("水里的碳酸钙")
                        Spacer()
                        Text("日文".localized + " & " + "英文".localized)
                            .foregroundColor(.gray)
                    }
                } icon: {
                    Image("avatar.hakubill")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                }
                Label {
                    HStack {
                        Text("ShikiSuen")
                        Spacer()
                        Text("繁体中文".localized + " & " + "日文".localized)
                            .foregroundColor(.gray)
                    }
                } icon: {
                    Image("avatar.shikisuen")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                }
                Menu {
                    Link(
                        destination: isInstallation(urlString: "twitter://") ?
                            URL(
                                string: "twitter://user?id=1593423596545724416"
                            )! :
                            URL(string: "https://twitter.com/hutao_hati")!
                    ) {
                        Label {
                            Text("Twitter主页")
                        } icon: {
                            Image("twitter")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Link(
                        destination: URL(
                            string: "https://youtube.com/c/hutao_taotao"
                        )!
                    ) {
                        Label {
                            Text("YouTube频道")
                        } icon: {
                            Image("youtube")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                } label: {
                    Label {
                        HStack {
                            Text("たお👻🍑")
                            Spacer()
                            Text("日文")
                                .foregroundColor(.gray)
                        }
                    } icon: {
                        Image("avatar.tao.2")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                    }
                }
                Label {
                    HStack {
                        Text("Qi")
                        Spacer()
                        Text("法文")
                            .foregroundColor(.gray)
                    }
                } icon: {
                    Image("avatar.qi")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                }
                Menu {
                    Link(
                        destination: isInstallation(urlString: "vk://") ?
                            URL(string: "vk://vk.com/arrteem40")! :
                            URL(string: "https://vk.com/arrteem40")!
                    ) {
                        Label {
                            Text("VK")
                        } icon: {
                            Image("vk")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                } label: {
                    Label {
                        HStack {
                            Text("Art34222")
                            Spacer()
                            Text("俄文")
                                .foregroundColor(.gray)
                        }
                    } icon: {
                        Image("avatar.Art34222")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                    }
                }
                Menu {
                    Link(
                        destination: URL(
                            string: "https://www.facebook.com/ngo.phi.phuongg"
                        )!
                    ) {
                        Label {
                            Text("Facebook主页")
                        } icon: {
                            Image("facebook")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                } label: {
                    Label {
                        HStack {
                            Text("Ngô Phi Phương")
                            Spacer()
                            Text("越南文")
                                .foregroundColor(.gray)
                        }
                    } icon: {
                        Image("avatar.ngo")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                    }
                }
                Link(destination: URL(string: "https://chat.openai.com/chat")!) {
                    Label {
                        HStack {
                            Text("ChatGPT")
                            Spacer()
                            Text("繁体中文")
                                .foregroundColor(.gray)
                        }
                    } icon: {
                        Image("chatgpt")
                            .resizable()
                            .foregroundColor(Color(UIColor(
                                red: 117 / 255,
                                green: 168 / 255,
                                blue: 156 / 255,
                                alpha: 1
                            )))
                            .scaledToFit()
                            .clipShape(Circle())
                    }
                }
            }
            Section(header: Text("特别鸣谢")) {
                Menu {
                    Link(
                        destination: URL(
                            string: "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=2251435011"
                        )!
                    ) {
                        Label {
                            Text("QQ")
                        } icon: {
                            Image("qq")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                } label: {
                    Label {
                        HStack {
                            Text("郁离居士")
                            Spacer()
                            Text("图片素材制作")
                                .foregroundColor(.gray)
                        }
                    } icon: {
                        Image("avatar.jushi")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                    }
                }
            }
        }
        .navigationTitle("开发者与联系方式")
        .navigationBarTitleDisplayMode(.inline)
    }

    func isInstallation(urlString: String?) -> Bool {
        let url = URL(string: urlString!)
        if url == nil {
            return false
        }
        if UIApplication.shared.canOpenURL(url!) {
            return true
        }
        return false
    }

    // MARK: Private

    @State
    private var isHakubillDetailShow = false
    @State
    private var isLavaDetailShow = false
    @State
    private var isShikiDetailShow = false
}

// MARK: - CaptionLabelStyle

private struct CaptionLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
    }
}
