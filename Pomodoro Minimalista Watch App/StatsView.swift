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
        VStack {
            Text("Today")
                .foregroundColor(.red)
                .font(.headline)
            Text("\(Int(timerController.dailySessionCount))")
                .foregroundColor(.red)
                .padding()
                .font(.title)
            Text("Total")
                .padding()
                .foregroundColor(.red)
                .font(.headline)
            Text("\(Int(timerController.totalSessionCount))")
                .foregroundColor(.red)
                .padding()
                .font(.title)
        }
    }
}

#Preview {
    StatsView(timerController: TimerController())
}
