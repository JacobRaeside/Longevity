//
//  LongevityApp.swift
//  Longevity
//
//  Created by Jacob Raeside on 5/26/24.
//

import SwiftUI
import UserNotifications

@main
struct LongevityApp: App {
    @StateObject private var healthData = HealthData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthData)
                .onAppear(perform: requestNotificationPermission)
                .onAppear(perform: scheduleDailyNotifications)
        }
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    private func scheduleDailyNotifications() {
        let center = UNUserNotificationCenter.current()
        
        let morningContent = UNMutableNotificationContent()
        morningContent.title = "Good Morning!"
        morningContent.body = "Remember to check your sleep data and have a beautiful day!"
        morningContent.sound = UNNotificationSound.default
        
        var morningDateComponents = DateComponents()
        morningDateComponents.hour = 8
        
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningDateComponents, repeats: true)
        let morningRequest = UNNotificationRequest(identifier: "morningReminder", content: morningContent, trigger: morningTrigger)
        
        center.add(morningRequest) { error in
            if let error = error {
                print("Error scheduling morning notification: \(error.localizedDescription)")
            }
        }
        
        let noonContent = UNMutableNotificationContent()
        noonContent.title = "Check Your Activity"
        noonContent.body = "Don't forget to check your activity rings for the day. Keep moving!"
        noonContent.sound = UNNotificationSound.default
        
        var noonDateComponents = DateComponents()
        noonDateComponents.hour = 12
        
        let noonTrigger = UNCalendarNotificationTrigger(dateMatching: noonDateComponents, repeats: true)
        let noonRequest = UNNotificationRequest(identifier: "noonReminder", content: noonContent, trigger: noonTrigger)
        
        center.add(noonRequest) { error in
            if let error = error {
                print("Error scheduling noon notification: \(error.localizedDescription)")
            }
        }
        
        let eveningContent = UNMutableNotificationContent()
        eveningContent.title = "Time to Journal"
        eveningContent.body = "Take some time before bed to journal about your day, your goals, dreams, and more!"
        eveningContent.sound = UNNotificationSound.default
        
        var eveningDateComponents = DateComponents()
        eveningDateComponents.hour = 21
        
        let eveningTrigger = UNCalendarNotificationTrigger(dateMatching: eveningDateComponents, repeats: true)
        let eveningRequest = UNNotificationRequest(identifier: "dailyJournalReminder", content: eveningContent, trigger: eveningTrigger)
        
        center.add(eveningRequest) { error in
            if let error = error {
                print("Error scheduling evening notification: \(error.localizedDescription)")
            }
        }
    }
}
