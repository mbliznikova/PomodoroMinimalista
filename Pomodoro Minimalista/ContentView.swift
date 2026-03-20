//
//  ContentView.swift
//  Pomodoro Minimalista
//
//  Created by Margarita Bliznikova on 3/18/25.
//

import SwiftUI
import Mixpanel

struct ContentView: View {
    @ObservedObject var store: AppDataStore

    var body: some View {
        NavigationStack(root: {

            Form {

                Section(
                    header: Text("SETTINGS"),
                    content: {
                        VStack {
                            Picker("Session Duration", selection: Binding(
                                get: { store.sessionMinutes },
                                set: {
                                    store.updateSessionMinutes($0)
                                    Mixpanel.mainInstance().track(
                                        event: "Settings",
                                        properties: [
                                            "Device": "Phone",
                                            "Setting type": "Session duration",
                                            "Setting value": "\($0)",
                                        ])
                                    Mixpanel.mainInstance().flush()
                                }
                            )) {
                                ForEach(1...60, id: \.self) { number in
                                    Text("\(Int(number))")
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                    })

                Section(
                    header: Text("STATISTICS"),
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

            }
            .navigationTitle("Session")
            .padding()

        })
    }

}

#Preview {
    ContentView(store: AppDataStore())
}
