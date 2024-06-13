//
//  SleepChartView.swift
//  Longevity
//
//  Created by Jacob Raeside on 6/3/24.
//

import SwiftUI
import Charts
import HealthKit

struct SleepChartView: View {
    var sleepData: [HKCategorySample]
    
    var body: some View {
        let sleepEntries = sleepData.map { sample in
            SleepEntry(
                start: sample.startDate,
                end: sample.endDate,
                value: sample.value
            )
        }
        
        VStack {
            Chart(sleepEntries) { entry in
                BarMark(
                    xStart: .value("Start Time", entry.start),
                    xEnd: .value("End Time", entry.end),
                    y: .value("Sleep Stage", sleepStageLabel(for: entry.value))
                )
                .foregroundStyle(by: .value("Sleep Stage", sleepStageLabel(for: entry.value)))
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 3)) { value in
                        AxisValueLabel(format: .dateTime.hour(.defaultDigits(amPM: .abbreviated)))
                        AxisGridLine()
                        AxisTick()
                    }
            }
            .chartYAxis {
                AxisMarks { _ in
                    AxisTick()
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
        }
    }
    
    private func sleepStageLabel(for value: Int) -> String {
        switch value {
        case HKCategoryValueSleepAnalysis.inBed.rawValue:
            return "In Bed"
        case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue:
            return "Asleep"
        case HKCategoryValueSleepAnalysis.awake.rawValue:
            return "Awake"
        case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
            return "Light"
        case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
            return "Deep"
        case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
            return "REM"
        default:
            return "Unknown"
        }
    }
}

struct SleepEntry: Identifiable {
    let id = UUID()
    let start: Date
    let end: Date
    let value: Int
}
