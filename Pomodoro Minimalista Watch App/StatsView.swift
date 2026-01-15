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
            Text("Sessions")
                .foregroundColor(.red)
                .font(.headline)
                .padding()
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
