//
//  WorkoutView.swift
//  Longevity
//
//  Created by Jacob Raeside on 5/26/24.
//

import SwiftUI
import HealthKit

struct WorkoutView: View {
    let workout: HKWorkout
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(workout.workoutActivityType.name)
                    .font(.headline)
                Spacer()
                Text(workout.startDate, formatter: dateFormatter)
            }
            Divider()
            HStack {
                Text("Duration: \((workout.duration / 60), specifier: "%.0f") mins")
                Spacer()
                Text("Calories: \(workout.totalEnergyBurned?.doubleValue(for: .largeCalorie()) ?? 0, specifier: "%.0f") cal")
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
