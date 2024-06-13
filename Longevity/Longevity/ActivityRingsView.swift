//
//  ActivityRingsView.swift
//  Longevity
//
//  Created by Jacob Raeside on 6/3/24.
//

import SwiftUI

struct ActivityRingsView: View {
    var moveCalories: Int
    var exerciseMinutes: Int
    
    var body: some View {
        HStack(spacing: 100) {
            VStack {
                Text("\(moveCalories)")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                Text("Move")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            VStack {
                Text("\(exerciseMinutes)")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                Text("Exercise")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

