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
    @State private var selectedMinutes: Int = 25

    var body: some View {
        NavigationStack(root: {

            Form {

                Section(
                    header: Text("SETTINGS"),
                    content: {
                        VStack {
                            Picker("Session Duration", selection: $selectedMinutes) {
                                ForEach(1...60, id: \.self) { number in
                                    Text("\(Int(number))")
                                }
                            }
                            .pickerStyle(.wheel)
                            .onChange(of: selectedMinutes) { _, newVal in
                                guard newVal != store.sessionMinutes else { return }
                                store.updateSessionMinutes(newVal)
                                Mixpanel.mainInstance().track(
                                    event: "Settings",
                                    properties: [
                                        "Device": "Phone",
                                        "Setting type": "Session duration",
                                        "Setting value": "\(newVal)",
                                    ])
                                Mixpanel.mainInstance().flush()
                            }
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
            .onAppear { selectedMinutes = store.sessionMinutes }
            .onChange(of: store.sessionMinutes) { _, newVal in
                selectedMinutes = newVal
            }

        })
    }

}

#Preview {
    ContentView(store: AppDataStore())
}
