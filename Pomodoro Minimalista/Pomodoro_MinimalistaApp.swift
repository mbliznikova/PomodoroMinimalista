//
//  Pomodoro_MinimalistaApp.swift
//  Pomodoro Minimalista
//
//  Created by Margarita Bliznikova on 3/18/25.
//

import SwiftUI
import Mixpanel

@main
struct Pomodoro_MinimalistaApp: App {
    @StateObject var store = AppDataStore()

    init() {
        Mixpanel.initialize(token: "TOKEN_HERE", trackAutomaticEvents: true, useUniqueDistinctId: true)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
