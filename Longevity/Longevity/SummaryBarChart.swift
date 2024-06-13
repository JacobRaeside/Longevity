//
//  SummaryBarChart.swift
//  Longevity
//
//  Created by Jacob Raeside on 5/26/24.
//

import SwiftUI
import Charts

struct SummaryBarChart: View {
    var totalHours: Double
    var deepSleepHours: Double
    
    var body: some View {
        Chart {
            BarMark(
                x: .value("Sleep Type", "Total Sleep"),
                y: .value("Hours", totalHours)
            )
            .foregroundStyle(Color.green)
            
            BarMark(
                x: .value("Sleep Type", "Deep Sleep"),
                y: .value("Hours", deepSleepHours)
            )
            .foregroundStyle(Color.purple)
        }
        .chartXAxis {
            AxisMarks { _ in
                AxisTick()
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisTick()
                AxisGridLine()
                AxisValueLabel()
            }
        }
    }
}
