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
    
    private var startDate: Date?

    private var timer: Timer?
    var timerInterval: TimeInterval = 1
    
    let duration: TimeInterval = 25 * 60
}
