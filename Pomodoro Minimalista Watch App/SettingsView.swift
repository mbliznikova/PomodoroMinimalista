//
//  SettingsView.swift
//  Pomodoro Minimalista
//
//  Created by Margarita Bliznikova on 1/5/26.
//

import SwiftUI

import Mixpanel

struct SettingsView: View {
    @ObservedObject var timerController: TimerController
    @State private var crownValue: Double = 25.0

    var body: some View {
        VStack {
            Text("Duration")
                .foregroundColor(.red)
                .font(.headline)
            Text("\(Int(crownValue)) min")
                .foregroundColor(.red)
                .font(.title)
                .padding()
                .focusable()
                .digitalCrownRotation(
                    $crownValue,
                    from: 1.0,
                    through: 60.0,
                    by: 1.0,
                    sensitivity: .low,
                    isContinuous: true,
                    isHapticFeedbackEnabled: true,
                )
                .disabled(timerController.isRunning)
                .onChange(of: crownValue) {
                    let minutes = Int(crownValue)
                    timerController.updateSessionMinutes(minutes)
                    Mixpanel.mainInstance().track(event: "Change session duration")
                }
                .onAppear() {
                    crownValue = Double(timerController.sessionMinutes)
                }
        }
    }
}

#Preview {
    SettingsView(timerController: TimerController())
}
