//
//  SeverityTracker.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI
import SwiftData


struct ItchTrackerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var itchLogs: [Itch]
    
    @State var face = 0
    @State var bodynum = 0
    @State var leftarm = 0
    @State var rightarm = 0
    @State var leftleg = 0
    @State var rightleg = 0
    
    @State var faceColor: Color = .black
    @State var bodyColor: Color = .black
    @State var leftArmColor: Color = .black
    @State var rightArmColor: Color = .black
    @State var leftLegColor: Color = .black
    @State var rightLegColor: Color = .black
    
    var average: Double {
        let sum = face + bodynum + leftarm + rightarm + leftleg + rightleg
        return Double(sum) / 6.0
    }
    
    @State var color: Color = .black
    let severityColors: [Color] = [.black, .green, .green, .yellow, .orange, .red]
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                BackgroundColor()
                
                VStack {
                    Text("Track your body's itch level by tapping on it")
                        .padding(.bottom, 30)
                    
                    Image("pip7")
                        .resizable()
                        .frame(width: 280, height: 330)
                        .padding(.bottom, 30)
                    
                    if let lastLog = itchLogs.last {
                        Text("Overall Severity: \(lastLog.severityLevel)")
                            .padding(.bottom, 30)
                    } else {
                        Text("No logs yet")
                    }
                    
                    Button("Save") {
                        saveLog()
                    }
                    .padding(.bottom, 30)
                    .tint(.pink)
                    .buttonStyle(.bordered)
                }
                
                ZStack {
                    Text("Face: \(face)")
                        .foregroundStyle(color)
                        .offset(x: -145, y: -190)
                        .contextMenu {
                            ForEach(0..<severityColors.count, id: \.self) { i in
                                Button("Severity: \(i)") {
                                    face = i
                                    color = severityColors[i]
                                }
                            }
                        }
                    
                    Text("Body: \(bodynum)")
                        .foregroundStyle(color)
                        .offset(x: 105, y: 25)
                        .contextMenu {
                            ForEach(0..<severityColors.count, id: \.self) { i in
                                Button("Severity: \(i)") {
                                    bodynum = i
                                    color = severityColors[i]
                                }
                            }
                        }
                    
                    Text("Left Arm: \(leftarm)")
                        .offset(x: -150, y: -10)
                        .frame(width: 80)
                        .contextMenu {
                            ForEach(0..<severityColors.count, id: \.self) { i in
                                Button("Severity: \(i)") {
                                    leftarm = i
                                    color = severityColors[i]
                                }
                            }
                        }
                    
                    
                    Text("Right Arm: \(rightarm)")
                        .foregroundStyle(color)
                        .offset(x: 160, y: -10)
                        .frame(width: 80)
                        .multilineTextAlignment(.trailing)
                        .contextMenu {
                            ForEach(0..<severityColors.count, id: \.self) { i in
                                Button("Severity: \(i)") {
                                    rightarm = i
                                    color = severityColors[i]
                                }
                            }
                        }
                    
                    Text("Left Leg: \(leftleg)")
                        .foregroundStyle(color)
                        .offset(x: -160, y: 100)
                        .frame(width: 80)
                        .contextMenu {
                            ForEach(0..<severityColors.count, id: \.self) { i in
                                Button("Severity: \(i)") {
                                    leftleg = i
                                    color = severityColors[i]
                                }
                            }
                        }
                    
                    Text("Right Leg: \(rightleg)")
                        .foregroundStyle(color)
                        .offset(x: 110, y: 100)
                        .frame(width: 80)
                        .multilineTextAlignment(.trailing)
                        .contextMenu {
                            ForEach(0..<severityColors.count, id: \.self) { i in
                                Button("Severity: \(i)") {
                                    rightleg = i
                                    color = severityColors[i]
                                }
                            }
                        }
                }
                .shadow(radius: 2)
                .bold()
                .font(.system(size: 20, design: .rounded))
                
            }
            .navigationTitle("Itch Tracker")
        }
    }
    func saveLog() {
        let log = Itch(average: average)
        modelContext.insert(log)
        
        do {
            try modelContext.save()
            print("Saved log with average: \(average), severity: \(log.severityLevel)")
        } catch {
            print("Failed to save log: \(error)")
        }
    }
    
}

#Preview {
    ItchTrackerView()
}
