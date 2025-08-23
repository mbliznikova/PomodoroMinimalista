//
//  ContentView.swift
//  Pomodoro Minimalista Watch App
//
//  Created by Margarita Bliznikova on 3/18/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var timerController: TimerController
    
    var body: some View {
        ZStack {

            Circle()
                .trim(from: 0, to: timerController.progress)
                .stroke(
                    Color.red,
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    ))
            //                .foregroundColor(.red)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))

            VStack{
                Text(timerController.isRunning ? "\(Int(timerController.remainingTime))" : "")
                    .foregroundColor(.red)
                    .bold()
                    .font(.system(size: 30))

                Button("", systemImage: timerController.isRunning ? "stop.fill" : "play.fill" ) {
                    timerController.toggleTimer()
                }
                .buttonStyle(PlainButtonStyle())
                .font(.system(size: 70))
                .foregroundStyle(.red)
                .padding()
            }.padding()

        }
        .padding(.bottom, 20)

    }
}

#Preview {
    ContentView(timerController: TimerController())
}
