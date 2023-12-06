//
//  ContentView.swift
//  BetterRest
//
//  Created by Leo Chung on 12/6/23.
//

import SwiftUI

// You can use Stepper to create a stepped numeric figure -> syntax includes text to display, value to change, in: for range, and step: for the steps
// You can form one-sided ranges in Swift -> Date.now... allows us to choose only up to future dates
// DateComponnets -> lets us read or write specific parts of a date rather than the whole thing



struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeeAmount = 1

    
    var body: some View {
//        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
//        DatePicker("Please enter a date", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute)
//            .labelsHidden()
//        Text(Date.now, format: .dateTime.hour().minute())
//        Text(Date.now.formatted(date: .long, time: .shortened))
        
        NavigationStack {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in: 1...20)
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
        }
    }
    
    func calculateBedTime() {
        print("FUCK")
    }
}

#Preview {
    ContentView()
}
