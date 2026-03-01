//
//  GameView.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI
import Charts
import SwiftData
//trigger graph
struct TriggerGraphView: View {
    @Query(sort: \TriggerData.id, order: .forward)
    var triggerData: [TriggerData]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Sleep Duration vs Severity")
                    .font(.title2)
                
                TriggerGraph(triggerData: triggerData)
            }
            .navigationTitle("Sleep Quality")
        }
    }
}

struct TriggerGraph: View {
    let triggerData: [TriggerData]
    
    var body: some View {
        Chart(triggerData) { dataPoint in
            BarMark(x: .value("Severity", dataPoint.severity), y: .value("Type", dataPoint.type))
                .foregroundStyle(dataPoint.tintColor)
                .annotation(position: .trailing) {
                    Text("\(dataPoint.severity)")
                        .foregroundColor(.gray)
                }
        }
        .chartLegend(.hidden)
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks { _ in
                AxisValueLabel()
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}

//sleep graph
struct SleepGraphView: View {
    @Query(sort: \SleepData.id, order: .forward)
    var sleepEntries: [SleepData]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Sleep Duration vs Severity")
                    .font(.title2)
                
                SleepGraph(sleepEntries: sleepEntries)
            }
            .navigationTitle("Sleep Quality")
        }
    }
}

struct SleepGraph: View {
    let sleepEntries: [SleepData]
    
    var recentEntries: ArraySlice<SleepData> {
        sleepEntries.suffix(7)
    }
    
    var data: [SleepDataSeries] {
        [SleepDataSeries(type: "Sleep Duration", data: buildDurationData(from: sleepEntries)),
         SleepDataSeries(type: "Severity", data: buildSeverityData(from: sleepEntries))]
    }
    var body: some View {
        Chart {
            ForEach(Array(recentEntries.enumerated()), id: \.element.id) { index, entry in
                let durationValue = Double(entry.duration) ?? 0
                let itchValue = Double(entry.itchLevel) ?? 0
                
                BarMark(
                    x: .value("Day", "Day \(index + 1)"),
                    y: .value("Value", durationValue)
                )
                .position(by: .value("Type", "Duration"))
                .foregroundStyle(by: .value("Type", "Duration"))
                
                // Itch level bar
                BarMark(
                    x: .value("Day", "Day \(index + 1)"),
                    y: .value("Value", itchValue)
                )
                .position(by: .value("Type", "Itch Level"))
                .foregroundStyle(by: .value("Type", "Itch Level"))
            }
        }
        .chartLegend(position: .bottom)
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}


#Preview {
    SleepGraphView()
        .modelContainer(for: SleepData.self, inMemory: true)
}
