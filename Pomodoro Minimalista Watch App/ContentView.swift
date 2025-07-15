//
//  ContentView.swift
//  Pomodoro Minimalista Watch App
//
//  Created by Margarita Bliznikova on 3/18/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var timerController:TimerController

    @State private var progress: Double = 0.3

    
    var body: some View {
        ZStack {

            Circle()
                .trim(from: 0, to: progress) // progress goes here?
                .stroke(
                    Color.red,
                    style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round
                        ))
//                .foregroundColor(.red)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))

            Button("", systemImage: timerController.isRunning ? "stop.fill" : "play.fill" ) {
                timerController.isRunning.toggle()
            }
            .buttonStyle(PlainButtonStyle())
            .font(.system(size: 70))
            .foregroundStyle(.red)
        }
    }
}

#Preview {
    ContentView(timerController: TimerController())
}
