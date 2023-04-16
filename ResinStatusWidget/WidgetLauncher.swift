//
//  WidgetLauncher.swift
//  ResinStatusWidgetExtension
//
//  Created by 戴藏龙 on 2022/9/12.
//

import Foundation

@main
enum WidgetLauncher {
    static func main() {
        if #available(iOSApplicationExtension 16.0, *) {
            WidgetsBundleiOS16.main()
        } else {
            WidgetsBundleLowerThaniOS16.main()
        }
    }
}
