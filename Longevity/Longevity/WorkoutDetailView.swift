//
//  WorkoutDetailView.swift
//  Longevity
//
//  Created by Jacob Raeside on 5/26/24.
//

import SwiftUI
import HealthKit

struct WorkoutDetailView: View {
    let workout: HKWorkout
    @State private var heartRateSamples: [HKQuantitySample] = []
    @State private var avgHeartRate: Double?
    @State private var maxHeartRate: Double?
    @State private var avgSpeed: Double?
    @State private var maxSpeed: Double?
    @State private var elevationGain: Double?
    @State private var avgPace: Double?
    @State private var avgCadence: Double?
    
    private let healthStore = HealthStore()
    
    private let distanceWorkouts = ["Walking", "Cycling", "Running", "Hiking", "Swimming"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(workout.workoutActivityType.name)
                    .font(.largeTitle)
                    .bold()
                Divider()
                
                HStack {
                    Text("Date:")
                    Spacer()
                    Text("\(workout.startDate, formatter: dateFormatter)")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Duration:")
                    Spacer()
                    Text("\(workout.duration / 60, specifier: "%.0f") minutes")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity)
                
                if distanceWorkouts.contains(workout.workoutActivityType.name) {
                    HStack {
                        Text("Miles:")
                        Spacer()
                        Text("\(workout.totalDistance?.doubleValue(for: .mile()) ?? 0, specifier: "%.2f") miles")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        let duration = workout.duration / 60
                        let distance = workout.totalDistance?.doubleValue(for: .mile()) ?? 0
                        let avgPace = duration / distance
                        Text("Average Pace:")
                        Spacer()
                        Text("\(avgPace, specifier: "%.2f") min/mi")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity)
                }
                
                if workout.workoutActivityType.name == "Walking" {
                    HStack {
                        Text("Average Speed:")
                        Spacer()
                        Text("\(avgSpeed ?? 0, specifier: "%.2f") mph")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        Text("Maximum Speed:")
                        Spacer()
                        Text("\(maxSpeed ?? 0, specifier: "%.2f") mph")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        Text("Elevation Gain:")
                        Spacer()
                        Text("\(elevationGain ?? 0, specifier: "%.0f") feet")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity)
                }
                
                HStack {
                    Text("Calories:")
                    Spacer()
                    Text("\(workout.totalEnergyBurned?.doubleValue(for: .largeCalorie()) ?? 0, specifier: "%.0f") cal")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Average Heart Rate:")
                    Spacer()
                    Text("\(avgHeartRate != nil ? String(format: "%.0f", avgHeartRate!) : "--") bpm")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Maximum Heart Rate:")
                    Spacer()
                    Text("\(maxHeartRate != nil ? String(format: "%.0f", maxHeartRate!) : "--") bpm")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity)
                
                if !heartRateSamples.isEmpty {
                    VStack(alignment: .center) {
                        Text("Heart Rate Over Time")
                            .font(.title2)
                    }
                    .frame(maxWidth: .infinity)
                    HeartRateChart(heartRateSamples: heartRateSamples, workout: workout)
                        .frame(height: 300)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Workout Details")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetchWorkoutStats()
                fetchHeartRateSamples()
                fetchSpeedSamples()
                fetchElevationGain()
            }
        }
    }
    
    private func fetchWorkoutStats() {
        healthStore.fetchAverageHeartRate(for: workout) { average, max in
            DispatchQueue.main.async {
                self.avgHeartRate = average
                self.maxHeartRate = max
            }
        }
    }
    
    private func fetchHeartRateSamples() {
        healthStore.fetchHeartRateSamples(for: workout) { samples in
            if let samples = samples {
                self.heartRateSamples = samples
            }
        }
    }
    
    private func fetchSpeedSamples() {
        healthStore.fetchSpeedSamples(for: workout) { samples in
            guard let samples = samples else { return }
            let speeds = samples.map { $0.quantity.doubleValue(for: .meter().unitDivided(by: .second())) * 2.23694 }
            print(speeds)
            DispatchQueue.main.async {
                self.avgSpeed = speeds.reduce(0, +) / Double(speeds.count)
                self.maxSpeed = speeds.max()
            }
        }
    }
        
    private func fetchElevationGain() {
        healthStore.fetchElevationGain(for: workout) { elevationGain in
            DispatchQueue.main.async {
                self.elevationGain = elevationGain
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
