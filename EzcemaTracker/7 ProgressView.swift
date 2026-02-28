//
//  GameView.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI
import Charts

struct ProgressView: View {
    var body: some View {
        ZStack {
            BackgroundColor()
        }
        
    }
}


struct SkinSeverityGraph: View {
    var body: some View {
        Text("Skin Severity Trend")
        Text("Line graph")
        Text("Track daily eczema condition: 0 = Clear skin, 1 = Mild, 2 = Moderate")
    }
}

struct SleepGraph: View {
    let sleepEntries: [SleepData]
    
    var data: [SleepDataSeries] {
        [SleepDataSeries(type: "Sleep Duration", data: buildDurationData(from: sleepEntries)), SleepDataSeries(type: "Severity", data: buildSeverityData(from: sleepEntries))]
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Sleep Duration vs Severity")
                    .bold()
                Chart(data) { series in
                    ForEach(series.data) { point in
                        LineMark(
                            x: .value("Entry", point.index),
                            y: .value(series.type, point.value)
                        )
                    }
                    .foregroundStyle(by: .value("Type", series.type))
                    .symbol(by: .value("Type", series.type))
                }
                .aspectRatio(1, contentMode: .fit)
                .padding()
            }
            .navigationTitle("Sleep Quality")
        }
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    let type: String
    let count: Int
}

struct SleepGraph2: View {
    let data = [ChartData(type: "bird", count: 1),
                ChartData(type: "dog", count: 2),
                ChartData(type: "cat", count: 3)]

    var maxChartData: ChartData? {
        data.max { $0.count < $1.count }
    }

    var body: some View {
        Chart {
            ForEach(data) { dataPoint in

                BarMark(x: .value("Type", dataPoint.type),
                        y: .value("Population", dataPoint.count))
                .foregroundStyle(Color.gray.opacity(0.5))
            }

            RuleMark(y: .value("Average", 1.5))
                .annotation(position: .bottom,
                            alignment: .bottomLeading) {
                    Text("average 1.5")
                        .foregroundColor(.accentColor)
                }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}


#Preview {
    SleepGraph2()
}
