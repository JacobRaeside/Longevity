//
//  WorkoutsView.swift
//  Longevity
//
//  Created by Jacob Raeside on 5/26/24.
//

import SwiftUI
import HealthKit

struct WorkoutsView: View {
    @EnvironmentObject var healthData: HealthData
    @State private var searchText = ""
    
    var filteredWorkouts: [HKWorkout] {
        if searchText.isEmpty {
            return healthData.workouts
        } else {
            return healthData.workouts.filter { workout in
                workout.workoutActivityType.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(filteredWorkouts, id: \.uuid) { workout in
                            NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                WorkoutView(workout: workout)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Workouts")
            .background(Color.clear)
            .onTapGesture {
                dismissKeyboard()
            }
        }
    }
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    WorkoutsView()
}
