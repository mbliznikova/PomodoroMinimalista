//
//  ContentView.swift
//  Pomodoro Minimalista
//
//  Created by Margarita Bliznikova on 3/18/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: AppDataStore

    var body: some View {
        VStack {

            VStack {
                Text("Session duration")
                    .font(.headline)
                    .foregroundColor(.red)
                Picker("Session duration", selection: Binding(
                    get: { store.sessionMinutes },
                    set: { store.updateSessionMinutes($0) }
                )) {
                    ForEach(1...60, id: \.self) { number in
                        Text("\(Int(number))")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
                .pickerStyle(.wheel)
            }

            VStack{
                Text("Sessions today: \(store.dailySessionCount)")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("Sessions total: \(store.totalSessionCount)")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView(store: AppDataStore())
}
