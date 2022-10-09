//
//  WatchGameInfoBlock.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/8.
//

import SwiftUI

struct WatchGameInfoBlock: View {
    var userData: Result<UserData, FetchError>
    let accountName: String?
    var uid: String?

    var fetchComplete: Bool
    var background: WidgetBackground

    @State var bindingBool = false

    var body: some View {
        switch userData {
        case .success(let data):
            ZStack {
                VStack(alignment: .leading) {
                    Text(accountName ?? "Name Nil")
                        .font(.caption)
                    HStack(alignment: .bottom) {
                        Text("\(data.resinInfo.currentResin)")
                            .font(.system(size: 50 , design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(Color("textColor3"))
                            .shadow(radius: 1)
                        Spacer()
                        Image("树脂")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                .opacity(fetchComplete ? 1 : 0)
                if !fetchComplete {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .padding()
            .background(
                Image(background.imageName!)
                    .resizable()
                    .scaledToFill()
                    .id(background.imageName!)
                    .transition(.opacity)
                    .opacity(fetchComplete ? 1 : 0)
            )
        case .failure(_):
            Text("Error")
        }
    }
}
