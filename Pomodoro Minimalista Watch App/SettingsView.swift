//
//  SettingsView.swift
//  Pomodoro Minimalista
//
//  Created by Margarita Bliznikova on 1/5/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var timerController: TimerController

    var body: some View {
        VStack {
            Text("Timer duration")
                .foregroundColor(.red)
            Picker("", selection: $timerController.sessionMinutes) {
                ForEach(1...60, id: \.self) {minutes in
                    Text("\(minutes) min")
                        .foregroundColor(.red)
                }
            }
            .onChange(of: timerController.sessionMinutes) { newValue in
                timerController.updateSessionMinutes(newValue)
            }
            .pickerStyle(.wheel)
            .disabled(timerController.isRunning)
            .background(Color.black)
        }
    }
}

#Preview {
    SettingsView(timerController: TimerController())
}
