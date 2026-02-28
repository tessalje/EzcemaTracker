//
//  Sleep.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 18/2/26.
//

import SwiftData
import SwiftUI

@Model
class SleepData: Identifiable {
    var id = UUID()
    var duration: String
    var wakeUps: Double
    var itchLevel: String
    
    init(id: UUID = UUID(), duration: String, wakeups: Double, itchlevel: String) {
        self.id = id
        self.duration = duration
        self.wakeUps = wakeups
        self.itchLevel = itchlevel
    }
}
    
struct SleepGraphPoint: Identifiable {
    let id = UUID()
    let index: Int
    let value: Int
}

struct SleepDataSeries: Identifiable {
    let id = UUID()
    let type: String
    let data: [SleepGraphPoint]
}

func buildSeverityData(from entries: [SleepData]) -> [SleepGraphPoint] {
    let recent = Array(entries.suffix(10))
    return (0..<10).map { i in
        let value = i < recent.count ? (Int(recent[i].itchLevel) ?? 0) : 0
        return SleepGraphPoint(index: i + 1, value: value)
    }
}

func buildDurationData(from entries: [SleepData]) -> [SleepGraphPoint] {
    let recent = Array(entries.suffix(10))
    return (0..<10).map { i in
        let value = i < recent.count ? (Int(recent[i].duration) ?? 0) : 0
        return SleepGraphPoint(index: i + 1, value: value)
    }
}


struct emojiView: View {
   @Binding var selectedEmoji: String
   var emojiText: String
   
   var body: some View {
       Button {
           withAnimation(.spring(response:0.3, dampingFraction: 0.5)){
               selectedEmoji = emojiText
           }
            
       } label:{
           Text(emojiText)
               .font(Font.custom("Avenir", size: 23))
       }
   }
}

struct SleepCard: View {
    let entry: SleepData
    let currentDate = Date()

    @State private var isShowingColor: Bool = false
    @Environment(\.modelContext) var modelContext
    
    private var wakeUpColor: Color {
        if entry.wakeUps <= 3 {
            return .green
        } else if entry.wakeUps >= 4 && entry.wakeUps <= 7 {
            return .orange
        } else {
            return .red
        }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .opacity(0.8)
                .shadow(radius: 2, x: 6, y: 5)
                .overlay(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Sleep entry on **\(Date.now, format: .dateTime.day().month().year())**:")
                                .font(.system(size: 21, design: .rounded))
                        }
                        Text("**Duration:** \(entry.duration)")
                            .font(.system(size: 16, design: .rounded))
                        
                        HStack(spacing: 5) {
                            Text("**Wake-ups:**")
                                .font(.system(size: 16, design: .rounded))
                                
                            Text("\(Int(entry.wakeUps))")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundStyle(wakeUpColor)
                                .bold()
                        }

                        Text("**Itch level:** \(entry.itchLevel)")
                            .font(.system(size: 16, design: .rounded))
                    }
                    .padding(20)
                }
                .frame(maxWidth: 380, minHeight: 130)
                .contextMenu {
                    Button(role: .destructive) {
                        modelContext.delete(entry)
                    }label: {
                        Label("Delete", systemImage: "trash")
                            .foregroundStyle(.red)
                    }
                }
        }
    }
}
