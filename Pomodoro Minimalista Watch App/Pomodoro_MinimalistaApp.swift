//
//  Pomodoro_MinimalistaApp.swift
//  Pomodoro Minimalista Watch App
//
//  Created by Margarita Bliznikova on 3/18/25.
//

import SwiftUI

@main
struct Pomodoro_Minimalista_Watch_AppApp: App {
    @StateObject var timerController: TimerController = TimerController()

    var body: some Scene {
        WindowGroup {
            ContentView(timerController: timerController)
        }
    }
}
