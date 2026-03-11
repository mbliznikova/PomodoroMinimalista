//
//  AppDataStore.swift
//  Pomodoro Minimalista
//
//  Created by Margarita Bliznikova on 3/10/26.
//

import Foundation

@MainActor
class AppDataStore: ObservableObject {
    @Published var sessionMinutes: Int
    @Published var totalSessionCount: Int
    @Published var dailySessionCount: Int

    init() {
        let saved = UserDefaults.standard.integer(forKey: "sessionMinutes")
        self.sessionMinutes = saved == 0 ? 25 : saved
        self.totalSessionCount = UserDefaults.standard.integer(forKey: "sessionsCount")
        self.dailySessionCount = UserDefaults.standard.integer(forKey: "dailySessionsCount")
    }

    func updateSessionMinutes(_ minutes: Int) {
        self.sessionMinutes = minutes
        UserDefaults.standard.set(minutes, forKey: "sessionMinutes")
    }
}
