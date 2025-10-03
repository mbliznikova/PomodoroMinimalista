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

        GeometryReader { geometry in
            let circleSize = min(geometry.size.width, geometry.size.height) * 0.95

            TimelineView(.periodic(from: .now, by: 1.0)) { context in
                let isLive = context.cadence == .live

                ZStack {
                    Circle()
                        .trim(from: 0, to: timerController.displayProgress(roundToMinutes: !isLive))
                        .stroke(
                            Color.red,
                            style: StrokeStyle(
                                lineWidth: max(circleSize * 0.03, 5),
                                lineCap: .round
                            ))
                    //                .foregroundColor(.red)
                        .frame(width: circleSize, height: circleSize)
                        .rotationEffect(.degrees(-90))
                        ._statusBarHidden()

                    VStack{
                        if timerController.isRunning {
                            Text(timerController.getFormattedRemainingTime(showSeconds: isLive))
                                .foregroundColor(.red)
                                .font(.system(size: min(circleSize * 0.2, 40)))
                        } else {
                            Button("", systemImage: "play.fill" ) {
                                timerController.toggleTimer()
                                WKInterfaceDevice.current().play(.start)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.system(size: min(circleSize * 0.4, 60)))
                            .foregroundStyle(.red)
                        }
                    }

                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .ignoresSafeArea(.all)

    }

}

#Preview {
    ContentView(timerController: TimerController())
}
