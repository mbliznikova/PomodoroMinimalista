//
//  Pomodoro_MinimalistaApp.swift
//  Pomodoro Minimalista
//
//  Created by Margarita Bliznikova on 3/18/25.
//

import SwiftUI

@main
struct Pomodoro_MinimalistaApp: App {
    @StateObject var store = AppDataStore()

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
