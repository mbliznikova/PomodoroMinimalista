//
//  TimerController.swift
//  Pomodoro Minimalista Watch App
//
//  Created by Margarita Bliznikova on 7/14/25.
//

import Foundation
import SwiftUI

@MainActor
class TimerController: ObservableObject {
    @Published var currentDateTime = Date()
    @Published var isRunning: Bool = false
    @Published var progress: CGFloat = 0.0

    private var startDate: Date?
    private var timer: Timer?
    private let timerInterval: TimeInterval = 0.05
    private let duration: TimeInterval = 25 * 60

    var elapsedTime: TimeInterval {
        guard let start = startDate else {return 0}
        return min(currentDateTime.timeIntervalSince(start), duration)
    }

    var remainingTime: TimeInterval {
        max(duration - elapsedTime, 0)
    }

    var formattedRemainingTime: String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
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

        self.timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) {_ in
            Task { @MainActor in
                self.updateTimeValues()

                if self.elapsedTime >= self.duration {
                    WKInterfaceDevice.current().play(.success)
                    usleep(250_000)
                    WKInterfaceDevice.current().play(.success)
                    usleep(250_000)
                    WKInterfaceDevice.current().play(.success)
                    usleep(250_000)

                    self.resetTimer()
                }
            }
        }
    }

    func resetTimer() {
        self.timer?.invalidate()
        self.timer = nil
        currentDateTime = Date()
        isRunning = false
        progress = 0.0
        startDate = Date()
    }
}
