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

    var onReceive: (([String: Any]) -> Void)?
    private let kvStore = NSUbiquitousKeyValueStore.default

    func activate() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        kvStore.synchronize()

        // Read initial values: iCloud KV first, fall back to UserDefaults
        var initial: [String: Any] = [:]
        for key in ["sessionMinutes", "sessionsCount", "dailySessionsCount"] {
            let cloud = Int(kvStore.longLong(forKey: key))
            let local = UserDefaults.standard.integer(forKey: key)
            let value = cloud > 0 ? cloud : local
            if value > 0 { initial[key] = value }
        }
        if !initial.isEmpty { onReceive?(initial) }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(iCloudChanged),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: kvStore
        )
    }

    @objc private func iCloudChanged() {
        var updated: [String: Any] = [:]
        for key in ["sessionMinutes", "sessionsCount", "dailySessionsCount"] {
            if let v = kvStore.object(forKey: key) { updated[key] = v }
        }
        if !updated.isEmpty {
            Task { @MainActor in self.onReceive?(updated) }
        }
    }

    func send(_ context: [String: Any]) {
        for (key, value) in context { kvStore.set(value, forKey: key) }
        kvStore.synchronize()
        guard WCSession.default.activationState == .activated else { return }
        do {
            try WCSession.default.updateApplicationContext(context)
        } catch {
            print("WatchSyncManager send failed: \(error)")
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        if let error = error { print("WatchSyncManager activation error: \(error)") }
    }

    func session(_ session: WCSession, didReceiveApplicationContext context: [String: Any]) {
        for (key, value) in context {
            if let v = value as? Int {
                UserDefaults.standard.set(v, forKey: key)
                kvStore.set(v, forKey: key)
            }
        }
        kvStore.synchronize()
        Task { @MainActor in self.onReceive?(context) }
    }
}
