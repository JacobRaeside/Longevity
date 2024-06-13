//
//  HealthData.swift
//  Longevity
//
//  Created by Jacob Raeside on 6/2/24.
//

import Foundation
import HealthKit

class HealthData: ObservableObject {
    @Published var workouts: [HKWorkout] = []
    @Published var showAlert = false
    
    @Published var moveCalories: Int = 0
    @Published var exerciseMinutes: Int = 0
    
    @Published var sleepData: [HKCategorySample] = []
    @Published var totalSleepDuration: TimeInterval = 0
    
    @Published var restingHeartRate: Double = 0.0
    @Published var heartRateVariability: Double = 0.0

    private var healthStore = HealthStore()
    
    func requestAuthorizationAndFetchData() {
        healthStore.requestAuthorization { [weak self] success in
            if success {
                self?.fetchData()
            } else {
              print("HealthKit auth not granted")
            }
        }
    }
    
    private func fetchData() {
        healthStore.fetchWorkouts { [weak self] workouts in
            DispatchQueue.main.async {
                self?.workouts = workouts ?? []
            }
        }
        
        healthStore.fetchActivityRingsData { [weak self] moveCalories, exerciseMinutes in
            DispatchQueue.main.async {
                self?.moveCalories = moveCalories
                self?.exerciseMinutes = exerciseMinutes
            }
        }
        
        healthStore.fetchSleepData { [weak self] sleepData in
            DispatchQueue.main.async {
                self?.sleepData = sleepData
                self?.processSleepData(sleepData)
            }
        }
        
        healthStore.fetchRestingHeartRate { [weak self] heartRate in
            DispatchQueue.main.async {
                self?.restingHeartRate = heartRate
            }
        }
        
        healthStore.fetchHeartRateVariability { [weak self] hrv in
            DispatchQueue.main.async {
                self?.heartRateVariability = hrv
            }
        }
    }
    
    private func processSleepData(_ sleepData: [HKCategorySample]) {
        guard !sleepData.isEmpty else {
            self.totalSleepDuration = 0
            return
        }
            
        let sortedSleepData = sleepData.sorted { $0.startDate < $1.startDate }

        let firstInBedSample = sortedSleepData.first { $0.value == HKCategoryValueSleepAnalysis.inBed.rawValue }
                
        let lastAwakeSample = sortedSleepData.last { $0.value == HKCategoryValueSleepAnalysis.awake.rawValue }

                
        guard let firstInBed = firstInBedSample, let lastAwake = lastAwakeSample else {
            self.totalSleepDuration = 0
            return
        }

        let totalDuration = lastAwake.endDate.timeIntervalSince(firstInBed.startDate)
        self.totalSleepDuration = totalDuration
    }
}
