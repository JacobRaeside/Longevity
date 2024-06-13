//
//  ProgressBar.swift
//  Longevity
//
//  Created by Jacob Raeside on 5/26/24.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(width: width, height: height)
                    .cornerRadius(10)

                Rectangle()
                    .foregroundColor(foregroundColor(for: value))
                    .frame(width: width * CGFloat(value), height: height)
                    .cornerRadius(10)
            }
        }
        .frame(height: 30)
        .cornerRadius(10)
        
        HStack(spacing: 0) {
            ForEach(0..<11) { index in
            Text("\(index * 10)%")
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    func foregroundColor(for value: Double) -> Color {
        switch value {
        case 0..<0.33:
            return Color.red
        case 0.33..<0.66:
            return Color.yellow
        default:
            return Color.green
        }
    }
}
