//
//  ContentView.swift
//  Pomodoro Minimalista Watch App
//
//  Created by Margarita Bliznikova on 3/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isTimerRunning: Bool = false
    
    var body: some View {
        ZStack {

            Circle()
                .stroke(lineWidth: 5)
                .foregroundColor(.red)
                .frame(width: 200, height: 200)

            Button("", systemImage: isTimerRunning ? "stop.fill" : "play.fill" ) {
                isTimerRunning.toggle()
            }
            .buttonStyle(PlainButtonStyle())
            .font(.system(size: 70))
            .foregroundStyle(.red)
        }
    }
}

#Preview {
    ContentView()
}
