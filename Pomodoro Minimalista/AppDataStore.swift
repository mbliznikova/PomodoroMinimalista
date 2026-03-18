//
//  AppDataStore.swift
//  Pomodoro Minimalista
//
//  Created by Margarita Bliznikova on 3/10/26.
//

import Foundation

@MainActor
class AppDataStore: ObservableObject {
    @Published var sessionMinutes: Int = 25
    @Published var totalSessionCount: Int = 0
    @Published var dailySessionCount: Int = 0

    private let syncManager = PhoneSyncManager.shared

    init() {
        syncManager.onReceive = { [weak self] context in
            guard let self else { return }
            if let v = context["sessionMinutes"] as? Int, v > 0 {
                self.sessionMinutes = v
                UserDefaults.standard.set(v, forKey: "sessionMinutes")
            }
            if let v = context["sessionsCount"] as? Int, v > 0 {
                self.totalSessionCount = v
                UserDefaults.standard.set(v, forKey: "sessionsCount")
            }
            if let v = context["dailySessionsCount"] as? Int, v > 0 {
                self.dailySessionCount = v
                UserDefaults.standard.set(v, forKey: "dailySessionsCount")
            }
        }
        syncManager.activate()
    }

    func updateSessionMinutes(_ minutes: Int) {
        self.sessionMinutes = minutes
        UserDefaults.standard.set(minutes, forKey: "sessionMinutes")
        syncManager.send(["sessionMinutes": minutes])
    }
}
