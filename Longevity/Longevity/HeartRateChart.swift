//
//  HeartRateChart.swift
//  Longevity
//
//  Created by Jacob Raeside on 6/2/24.
//

import SwiftUI
import Charts
import HealthKit

struct HeartRateChart: View {
    let heartRateSamples: [HKQuantitySample]
    let workout: HKWorkout
    
    var body: some View {
        let data = heartRateSamples.map { sample in
            HeartRateData(
                time: sample.startDate.timeIntervalSince(workout.startDate) / 60,
                heartRate: sample.quantity.doubleValue(for: .count().unitDivided(by: .minute()))
            )
        }
        
        return Chart(data) { item in
            LineMark(
                x: .value("Time", item.time),
                y: .value("Heart Rate", item.heartRate)
            )
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisValueLabel() {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue) bpm")
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { value in
                AxisValueLabel() {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue) min")
                    }
                }
            }
        }
    }
}

struct HeartRateData: Identifiable {
    let id = UUID()
    let time: TimeInterval
    let heartRate: Double
}
