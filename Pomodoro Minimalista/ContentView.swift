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
        Form {

            Section(
                header: Text("Session duration")
                    .foregroundColor(.red.opacity(0.8)),
                content: {
                    VStack {
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
                })

            Section(
                header: Text("Session count")
                    .foregroundColor(.red.opacity(0.8)),
                content: {
                    VStack(alignment: .leading){
                        Text("Today: \(store.dailySessionCount)")
                            .font(.headline)
                            .foregroundColor(.red)
                        Spacer()
                        Text("Total: \(store.totalSessionCount)")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    .padding()
                })

        }.padding()
    }

}

#Preview {
    ContentView(store: AppDataStore())
}
