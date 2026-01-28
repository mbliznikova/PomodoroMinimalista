//
//  ContentView.swift
//  Pomodoro Minimalista
//
//  Created by Margarita Bliznikova on 3/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var pickerValue: Double = 25.0

    var body: some View {
        VStack {

            VStack {
                Text("Session duration")
                    .font(.headline)
                    .foregroundColor(.red)
                Picker("Session duration", selection: $pickerValue) {
                    ForEach(1...60, id: \.self) { number in
                        Text("\(Int(number))")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
                .pickerStyle(.wheel)
            }

            VStack{
                Text("Sessions today")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("Sessions total")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
