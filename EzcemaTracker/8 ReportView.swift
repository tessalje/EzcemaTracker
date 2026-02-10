//
//  Untitled.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI

struct ReportView: View {
    var body: some View {
        Text("")
    }
}

struct EfficiencyView: View {
    
    var progress: Double = 0.89   // 89%
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("My Efficiency")
                .font(.title)
                .bold()
            
            ZStack{
                Circle()
                    .stroke(
                        Color.gray.opacity(0.15),
                        lineWidth: 25
                    )
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.8),
                                Color.green
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(
                            lineWidth: 25,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: Color.green.opacity(0.4),
                            radius: 10)
                    .animation(.easeInOut, value: progress)
                
                VStack {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 48, weight: .bold))
                    
                    Text("of tasks completed")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 220, height: 220)
            
        }
        .padding()
    }
}

#Preview {
    EfficiencyView()
}
