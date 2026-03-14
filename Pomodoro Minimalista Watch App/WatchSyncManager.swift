//
//  WatchSyncManager.swift
//  Pomodoro Minimalista Watch App
//
//  Created by Margarita Bliznikova on 3/12/26.
//

import Foundation
import WatchConnectivity

class WatchSyncManager: NSObject, WCSessionDelegate {

    static let shared = WatchSyncManager()

    var watchSession: WCSession

    @Published var sessionMinutes: Int = 0
    @Published var dailySessionCount: Int = 0
    @Published var totalSessionCount: Int = 0

    private let kvStore = NSUbiquitousKeyValueStore.default

    override init() {
        self.watchSession = WCSession.default
        super.init()

        assert(WCSession.isSupported(), "WatchSyncManager: WCSession should be supported")
        self.watchSession.delegate = self
        self.watchSession.activate()

        // TODO: add check if user uses iCloud?
        kvStore.synchronize() // TODO: how to make sure the latest changes propagate?
        let cloudMinutes = Int(kvStore.longLong(forKey: "sessionMinutes"))
        let cloudDaily = Int(kvStore.longLong(forKey: "dailySessionCount"))
        let cloudTotal = Int(kvStore.longLong(forKey: "totalSessionCount"))

        sessionMinutes = cloudMinutes > 0 ? cloudMinutes : UserDefaults.standard.integer(forKey: "sessionMinutes")
        dailySessionCount = cloudDaily > 0 ? cloudDaily : UserDefaults.standard.integer(forKey: "dailySessionCount")
        totalSessionCount = cloudTotal > 0 ? cloudTotal : UserDefaults.standard.integer(forKey: "totalSessionCount")

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getFromICloud),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: kvStore
        )
    }

    @objc private func getFromICloud() {
        Task { @MainActor in
            sessionMinutes = Int(kvStore.longLong(forKey: "sessionMinutes"))
            dailySessionCount = Int(kvStore.longLong(forKey: "dailySessionCount"))
            totalSessionCount = Int(kvStore.longLong(forKey: "totalSessionCount"))
        }
    }

    // TODO: handle iCloud vs UserDefaults
    func sendSettings(minutes: Int) {
        guard watchSession.activationState == .activated else { return }
        do {
            try watchSession.updateApplicationContext(["sessionMinutes": minutes])
        } catch {
            print("Failed to send settings: \(error)")
        }
    }

    // TODO: handle iCloud vs UserDefaults
    func sendStats(dailyCount: Int, totalCount: Int) {
        guard watchSession.activationState == .activated else { return }
        watchSession.transferUserInfo([
            "dailySessionCount": dailyCount,
            "totalSessionCount": totalCount,
        ])
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if error != nil {
            print("\(Date()) WatchSyncManager: the error is \(String(describing: error))")
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        Task { @MainActor in
            if let minutes = userInfo["sessionMinutes"] as? Int { // TODO: handle iCloud vs UserDefaults
//            if let minutes = applicationContext["sessionMinutes"] as? Int {
                self.sessionMinutes = minutes
                UserDefaults.standard.set(minutes, forKey: "sessionMinutes")
                kvStore.set(minutes, forKey: "sessionMinutes")
                kvStore.synchronize()
            }
        }
    }
}
