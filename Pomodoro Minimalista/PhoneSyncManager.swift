//
//  PhoneSyncManager.swift
//  Pomodoro Minimalista
//
//  Created by Margarita Bliznikova on 3/12/26.
//

import Combine
import Foundation
import WatchConnectivity

class PhoneSyncManager: NSObject, WCSessionDelegate {
    static let shared = PhoneSyncManager()

    var onReceive: (([String: Any]) -> Void)?
    private let kvStore = NSUbiquitousKeyValueStore.default

    func activate() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        kvStore.synchronize()

        var initial: [String: Any] = [:]
        for key in ["sessionMinutes", "sessionsCount", "dailySessionsCount"] {
            let cloud = Int(kvStore.longLong(forKey: key))
            let local = UserDefaults.standard.integer(forKey: key)
            let value = cloud > 0 ? cloud : local
            if value > 0 {initial[key] = value}
        }
        if !initial.isEmpty {
            Task { @MainActor in self.onReceive?(initial) }
        }

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
            if let v = kvStore.object(forKey: key) {updated[key] = v}
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
            print("PhoneSyncManager WCSession send failed: \(error)")
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
            if let error = error { print("WatchSyncManager activation error: \(error)") }
    }
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) { WCSession.default.activate() }

    func session(_ session: WCSession, didReceiveApplicationContext context: [String: Any]) {
        Task { @MainActor in
            for (key, value) in context {
                if key == "lastRecordedDate" {
                    if let ts = (value as? NSNumber)?.doubleValue, ts > 0 {
                        kvStore.set(ts, forKey: key)
                        UserDefaults.standard.set(ts, forKey: key)
                    }
                } else if let v = value as? Int {
                    UserDefaults.standard.set(v, forKey: key)
                    kvStore.set(v, forKey: key)
                }
            }
            self.onReceive?(context)
        }
    }
}
