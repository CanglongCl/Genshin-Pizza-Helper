//
//  BackgroundsPreviewView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/22.
//  背景名片预览View

import SwiftUI

// MARK: - BackgroundsPreviewView

struct BackgroundsPreviewView: View {
    // MARK: Internal

    let backgroundOptions: [String] = BackgroundOptions.namecards

    var body: some View {
        if #available(iOS 15.0, *) {
            List {
                ForEach(searchResults, id: \.self) { backgroundImageName in
                    Section {
                        WidgetBackgroundView(
                            background: generateBackground(backgroundImageName),
                            darkModeOn: false
                        )
                        .listRowInsets(.init(
                            top: 0,
                            leading: 0,
                            bottom: 0,
                            trailing: 0
                        ))
                        .clipShape(RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        ))
                    } header: {
                        Text(
                            backgroundImageName
                                .localizedWithFix
                        )
                    }
                    .textCase(.none)
                    .listRowBackground(Color.white.opacity(0))
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText)
            .navigationTitle("背景名片预览")
        } else {
            List {
                ForEach(backgroundOptions, id: \.self) { backgroundImageName in
                    Section {
                        WidgetBackgroundView(
                            background: generateBackground(backgroundImageName),
                            darkModeOn: false
                        )
                        .listRowInsets(.init(
                            top: 0,
                            leading: 0,
                            bottom: 0,
                            trailing: 0
                        ))
                        .clipShape(RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        ))
                    } header: {
                        Text(
                            backgroundImageName
                                .localizedWithFix
                        )
                    }
                    .textCase(.none)
                    .listRowBackground(Color.white.opacity(0))
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("背景名片预览")
        }
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return backgroundOptions
        } else {
            return backgroundOptions
                .filter {
                    $0.localizedWithFix.lowercased()
                        .contains(searchText.lowercased())
                }
        }
    }

    func generateBackground(_ backgroundString: String) -> WidgetBackground {
        WidgetBackground(
            identifier: backgroundString,
            display: backgroundString
        )
    }

    // MARK: Private

    @State
    private var searchText = ""
}

// MARK: - BackgroundsPreviewView_Previews

@available(iOS 15.0, *)
struct BackgroundsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundsPreviewView()
    }
}
