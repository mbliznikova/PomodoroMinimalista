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
                header: Text("Session duration"),
                content: {
                    VStack {
                        Picker("Session duration", selection: Binding(
                            get: { store.sessionMinutes },
                            set: { store.updateSessionMinutes($0) }
                        )) {
                            ForEach(1...60, id: \.self) { number in
                                Text("\(Int(number))")
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                })

            Section(
                header: Text("Session count"),
                content: {
                    VStack(alignment: .leading) {
                        HStack{
                            Text("Today")
                            Spacer()
                            Text("\(store.dailySessionCount)")
                        }
                        Spacer()
                        Divider()
                        HStack{
                            Text("Total")
                            Spacer()
                            Text("\(store.totalSessionCount)")
                        }
                    }
                    .padding()
                })

        }.padding()
    }

}

#Preview {
    ContentView(store: AppDataStore())
}
