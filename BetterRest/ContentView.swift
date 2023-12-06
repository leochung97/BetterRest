import CoreML
import SwiftUI

// You can use Stepper to create a stepped numeric figure -> syntax includes text to display, value to change, in: for range, and step: for the steps
// You can form one-sided ranges in Swift -> Date.now... allows us to choose only up to future dates
// DateComponnets -> lets us read or write specific parts of a date rather than the whole thing

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    let cups = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    // Without static, this would fail to compile as we are accessing one property from inside another
    // You need static to know that defaultWakeTime belongs to the ContentView struct itself rather than a single instance of the struct -> this means defaultWakeTime can be read whenever we want
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        // Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
        // DatePicker("Please enter a date", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute)
        //     .labelsHidden()
        // Text(Date.now, format: .dateTime.hour().minute())
        // Text(Date.now.formatted(date: .long, time: .shortened))
        
        NavigationStack {
            Form {
                Section("Wake Up Time") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                }
                .font(.headline)
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                .font(.headline)
                
                Section("Daily coffee intake") {
                    // We can tell SwiftUI that the word cup needs to be "inflected" to match whatever is in the coffeeAmount variable -> this will automatically convert cup to cups if appropriate
                    // Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                    Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount) {
                        ForEach(cups, id: \.self) { cup in
                            Text("\(cup)").tag(cup)
                        }q
                    }
                }
                .font(.headline)
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep

            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }

        showingAlert = true
    }
}

#Preview {
    ContentView()
}
