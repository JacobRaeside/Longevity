//
//  InfoView.swift
//  Longevity
//
//  Created by Jacob Raeside on 6/5/24.
//

import SwiftUI

enum InfoType {
    case overallHealth
    case sleepMetrics
    case journalInfo
}

struct InfoView: View {
    let infoType: InfoType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            switch infoType {
            case .overallHealth:
                Text("Overall Health")
                    .font(.largeTitle)
                    .bold()
                Text("The Overall Health score is calculated based on the following factors:")
                Text("- Activity Score: Based on your move calories compared to a minimum of 500 burned daily and your exercise minutes compared to 60 minutes of exercise a day.")
                Text("- Heart Rate Score: Based on your resting heart rate compared to the benchmark resting heart rate of 60 bpm.")
                Text("- Heart Rate Variability Score: Based on your heart rate variability compared to the benchmark resting heart rate of 50 ms.")
                Text("- Sleep Score: Based on your total hours slept the previous night compared to the 8 hour benchmark.")
                Text("Each factor contributes to the overall score, with a maximum possible score of 1.0 or 100%.")
            case .sleepMetrics:
                Text("Sleep Metrics")
                    .font(.largeTitle)
                    .bold()
                Text("The Sleep Metrics chart displays your sleep data including:")
                Text("- In Bed: The total amount of time spent in bed.")
                Text("- Asleep: The total amount of time asleep.")
                Text("- Light: The total amount of time in light sleep.")
                Text("- Deep: The total amount of time in deep sleep.")
                Text("- Awake: The total amount of time awake.")
                Text("- REM: The total amount of time in REM sleep.")
            case .journalInfo:
                Text("Journaling Benefits")
                    .font(.largeTitle)
                    .bold()
                Text("Keeping a journal can have several benefits for your mental and physical health:")
                Text("- Stress Reduction: Writing about your thoughts and feelings can help reduce stress and anxiety.")
                Text("- Improved Mood: Regular journaling can improve your mood and emotional well-being.")
                Text("- Enhanced Memory: Journaling can boost your memory and comprehension.")
                Text("- Better Sleep: Reflecting on your day and expressing your thoughts can help you sleep better.")
                Text("- Increased Self-Awareness: Journaling helps you understand yourself better and gain clarity on your thoughts and behaviors.")
                Text("- Goal Setting: Writing down your goals can increase your chances of achieving them.")
            }
        }
        .padding()
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
    }
}
