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
        VStack {
            Button("", systemImage: isTimerRunning ? "stop.fill" : "play.fill" ) {
                isTimerRunning.toggle()
            }
            .buttonStyle(PlainButtonStyle())
            .font(.system(size: 40))
            .foregroundStyle(.red)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
