//
//  Pomodoro_MinimalistaApp.swift
//  Pomodoro Minimalista Watch App
//
//  Created by Margarita Bliznikova on 3/18/25.
//

import SwiftUI

import Mixpanel

@main
struct Pomodoro_Minimalista_Watch_AppApp: App {
    enum TabIdentifier: Hashable {
        case main
        case settings
        case stats
    }

    @StateObject var timerController: TimerController = TimerController()
    @State private var selectedTab = TabIdentifier.main

    init() {
        Mixpanel.initialize(token: "TOKEN_HERE", useUniqueDistinctId: true)
    }

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                SettingsView(timerController: timerController)
                    .tag(TabIdentifier.settings)
                ContentView(timerController: timerController)
                    .tag(TabIdentifier.main)
                StatsView()
                    .tag(TabIdentifier.stats)
            }.tabViewStyle(.page)
        }
    }
}
