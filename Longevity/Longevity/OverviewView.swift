//
//  OverviewView.swift
//  Longevity
//
//  Created by Jacob Raeside on 5/26/24.
//

import SwiftUI
import HealthKit

struct OverviewView: View {
    
    private let healthStore = HealthStore()
    
    @EnvironmentObject var healthData: HealthData
    @State private var showInfoSheet = false
    @State private var infoType: InfoType?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .center) {
                        HStack {
                            Text("Overall Health")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                infoType = .overallHealth
                                showInfoSheet = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                        ProgressBar(value: calculateOverallHealth())
                            .frame(height: 20)
                            .padding(.vertical)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    
                    VStack(alignment: .center) {
                        Text("Activity Rings Summary")
                            .font(.headline)
                        ActivityRingsView(moveCalories: healthData.moveCalories, exerciseMinutes: healthData.exerciseMinutes)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        Text("Recent Workouts")
                            .font(.headline)
                        ForEach(healthData.workouts.prefix(3), id: \.uuid) { workout in
                            NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                WorkoutView(workout: workout)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    
                    VStack(alignment: .center) {
                        HStack {
                            Text("Sleep Metrics")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                infoType = .sleepMetrics
                                showInfoSheet = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                        if !healthData.sleepData.isEmpty {
                            SleepChartView(sleepData: healthData.sleepData)
                                .frame(height: 300)
                                .padding()
                        } else {
                            Text("No sleep data available currently.")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Overview")
            .onAppear {
                healthData.requestAuthorizationAndFetchData()
            }
            .sheet(isPresented: $showInfoSheet) {
                InfoView(infoType: infoType ?? .overallHealth)
            }
        }
    }
    
    private func calculateOverallHealth() -> Double {
        var activityScore = (Double(healthData.moveCalories) / 500.0) * 0.2 + (Double(healthData.exerciseMinutes) / 60.0) * 0.2
        var heartRateScore = healthData.restingHeartRate > 0 ? (60.0 / healthData.restingHeartRate) * 0.2 : 0
        var hrvScore = healthData.heartRateVariability > 0 ? (healthData.heartRateVariability / 50.0) * 0.2 : 0
        var sleepScore = healthData.totalSleepDuration > 0 ? (8 / (healthData.totalSleepDuration / 3600)) * 0.2 : 0
        activityScore = activityScore < 0.41 ? activityScore : 0.40
        heartRateScore = heartRateScore < 0.21 ? heartRateScore : 0.20
        hrvScore = hrvScore < 0.21 ? hrvScore : 0.20
        sleepScore = sleepScore < 0.21 ? sleepScore : 0.20
        return min(activityScore + sleepScore + heartRateScore + hrvScore, 1.0)
    }
}


#Preview {
    OverviewView()
}
