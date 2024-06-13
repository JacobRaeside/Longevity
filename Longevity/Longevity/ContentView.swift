//
//  ContentView.swift
//  Longevity
//
//  Created by Jacob Raeside on 5/26/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthData: HealthData
    
    var body: some View {
        TabView {
            OverviewView()
                .tabItem {
                    Label("Overview", systemImage: "house")
                }
            
            WorkoutsView()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell.fill")
                }
            
            SleepView()
                .tabItem {
                    Label("Sleep", systemImage: "bed.double")
                }
        }
        .onAppear {
            healthData.requestAuthorizationAndFetchData()
        }
    }
}


#Preview {
    ContentView()
}
