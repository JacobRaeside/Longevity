//
//  SleepView.swift
//  Longevity
//
//  Created by Jacob Raeside on 5/26/24.
//

import SwiftUI
import HealthKit

struct SleepView: View {
    
    @EnvironmentObject var healthData: HealthData
    @State private var journalEntry: String = ""
    @State private var journalEntries: [JournalEntry] = []
    @State private var showInfoSheet = false
    @State private var infoType: InfoType?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
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
                            Text("Total Sleep Duration")
                                .font(.headline)
                            Text("\(formatTimeInterval(healthData.totalSleepDuration))")
                                .padding(.top, 5)
                        } else {
                            Text("No sleep data available currently.")
                                .padding()
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Journal Entry")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                infoType = .journalInfo
                                showInfoSheet = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                        TextField("Enter your journal entry here", text: $journalEntry)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                        Button(action: {
                            if journalEntry != "" {
                                saveJournalEntry()
                                dismissKeyboard()
                            }
                        }) {
                            Text("Save Entry")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                        
                        ForEach(journalEntries) { entry in
                            VStack(alignment: .leading) {
                                Text("\(entry.date, formatter: dateFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(entry.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Sleep")
            .onAppear {
                healthData.requestAuthorizationAndFetchData()
            }
            .onTapGesture {
                dismissKeyboard()
            }
            .sheet(isPresented: $showInfoSheet) {
                InfoView(infoType: infoType ?? .sleepMetrics)
            }
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func saveJournalEntry() {
        let newEntry = JournalEntry(date: Date(), text: journalEntry)
        journalEntries.insert(newEntry, at: 0)
        journalEntry = ""
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = Int(interval.truncatingRemainder(dividingBy: 3600)) / 60
        return String("\(hours) hours and \(minutes) minutes")
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

struct JournalEntry: Identifiable {
    let id = UUID()
    let date: Date
    let text: String
}

#Preview {
    SleepView()
}
