//
//  TimerController.swift
//  Pomodoro Minimalista Watch App
//
//  Created by Margarita Bliznikova on 7/14/25.
//

import Foundation
import SwiftUI
import UserNotifications
import WatchKit

import Mixpanel

@MainActor
class TimerController: ObservableObject {
    @Published var totalSessionCount: Int
    @Published var sessionMinutes: Int
    @Published var currentDateTime = Date()
    @Published var isRunning: Bool = false
    @Published var progress: CGFloat = 0.0
    private var startDate: Date?

    private var timer: Timer?
    private let timerInterval: TimeInterval = 0.05

    var duration: TimeInterval {
        TimeInterval(self.sessionMinutes * 60)
    }

    func updateSessionMinutes(_ minutes: Int) {
        self.sessionMinutes = minutes
        UserDefaults.standard.set(minutes, forKey: "sessionMinutes")
    }

    func incrementTotalSessionsCount() {
        self.totalSessionCount += 1
        UserDefaults.standard.set(self.totalSessionCount + 1, forKey: "sessionsCount")
    }

    var elapsedTime: TimeInterval {
        guard let start = startDate else {return 0}
        return min(Date().timeIntervalSince(start), duration)
    }

    var remainingTime: TimeInterval {
        max(duration - elapsedTime, 0)
    }

    func getFormattedRemainingTime(showSeconds: Bool) -> String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return showSeconds ? String(format: "%02d:%02d", minutes, seconds) : String(format:"%02d:--", minutes)
    }

    func displayProgress(roundToMinutes: Bool) -> CGFloat {
        if roundToMinutes {
            let durationMinutes = Int(duration / 60)
            let elapsedMinutes = Int(elapsedTime / 60)
            let minuteProgress = CGFloat(elapsedMinutes) / CGFloat(durationMinutes)

            return max(minuteProgress, 0.001)
        }
        return self.progress
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {granted, error in
            if let error = error {
                print("Notification permission error \(error)")
            }
        }
    }

    func scheduleNotification(after seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Complete"
        content.body = "Your focus session is done"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "pomodoroTimer", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) {error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully!")
            }
        }
    }

    func toggleTimer() {
        if self.isRunning {
            self.resetTimer()
        } else {
            self.startTimer()
        }
    }

    func updateTimeValues() {
        self.currentDateTime = Date()
        self.progress = CGFloat(elapsedTime / duration)
    }

    func startTimer() {
        self.currentDateTime = Date()
        self.isRunning = true
        self.startDate = Date()
        self.progress = 0.0

        self.timer?.invalidate()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["pomodoroTimer"])

        self.scheduleNotification(after: self.duration)

        self.timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) {_ in
            Task { @MainActor in
                self.updateTimeValues()

                if self.elapsedTime >= self.duration {
                    if WKExtension.shared().applicationState == .active {
                        WKInterfaceDevice.current().play(.notification) // To be consistent with system alert (default for UNMutableNotificationContent)
                    }

                    Mixpanel.mainInstance().track(event: "Stop timer")
                    Mixpanel.mainInstance().flush()
                    self.incrementTotalSessionsCount()
                    self.resetTimer()
                }
            }
        }
    }

    func resetTimer() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["pomodoroTimer"])
        self.timer?.invalidate()
        self.timer = nil
        currentDateTime = Date()
        isRunning = false
        progress = 0.0
        startDate = nil
    }

    init() {
        let savedMinutes = UserDefaults.standard.integer(forKey: "sessionMinutes")
        self.sessionMinutes = savedMinutes == 0 ? 25 : savedMinutes
        self.totalSessionCount = UserDefaults.standard.integer(forKey: "sessionsCount")
        requestNotificationPermission()
    }
}
