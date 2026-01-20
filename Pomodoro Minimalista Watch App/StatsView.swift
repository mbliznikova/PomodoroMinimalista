//
//  StatsView.swift
//  Pomodoro Minimalista
//
//  Created by Margarita Bliznikova on 1/12/26.
//

import SwiftUI

import Mixpanel


struct StatsView: View {
    @ObservedObject var timerController: TimerController

    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            VStack {
                Text("\(Int(timerController.dailySessionCount))")
                    .foregroundColor(.red)
                    .font(.system(size: 48))
                Text("Today")
                    .foregroundColor(.red)
                    .font(.caption)

            }
            VStack {
                Text("\(Int(timerController.totalSessionCount))")
                    .font(.system(size: 48))
                    .foregroundColor(.red)
                Text("Total")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            Spacer()
        }
    }
}

#Preview {
    StatsView(timerController: TimerController())
}
