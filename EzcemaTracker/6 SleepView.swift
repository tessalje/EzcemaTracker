//
//  Slee.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI
import Foundation
import SwiftData

struct SleepView: View {
    @State private var isShowingSheet = false
    @Query private var entries: [SleepData]
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()
                ScrollView {
                    Text("How was your sleep today?")
                        .padding(.trailing, 155)
                    ForEach(entries) { entry in
                        SleepCard(entry: entry)
                    }
                }
            }
            .navigationTitle("Sleep Tracker")
            .overlay(alignment: .bottomTrailing, content: {
                Button(action: {
                    isShowingSheet.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 55, height: 55)
                        .background(.blue.shadow(.drop(color: .black.opacity(0.4), radius:5, x: 2, y: 4)), in: .circle)
                        .padding()
                })
            })
            .sheet(isPresented: $isShowingSheet) {
                SleepForm()
                    .presentationDetents([.height(550)])
                    .interactiveDismissDisabled()
                    .presentationCornerRadius(30)
            }
        }
    }
}

struct SleepForm: View {
    @Environment(\.modelContext) private var modelContext

    @State private var selectedStartHour = Date()
    @State private var selectedEndHour = Date()
    @State private var value: Double = 0.0
    
    @Environment(\.dismiss) private var dismiss
    
    let reactions = ["😫", "☹️", "🙂", "😴"]
    @State var selectedEmoji: String = ""
    
    var sleepDuration: String {
        if selectedEndHour <= selectedStartHour {
            selectedEndHour = Calendar.current.date(byAdding: .day, value: 1, to: selectedEndHour) ?? selectedEndHour
        }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: selectedStartHour, to: selectedEndHour)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        return "\(abs(hours))h \(abs(minutes))m"
    }
    
    @State private var isfilled: Bool = false
    
    var body: some View {
    
        VStack(alignment: .leading, spacing: 15, content: {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName:"xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .padding(.leading, 5)
            
            Text("How was your sleep last night?🌙")
                .font(.system(size: 20))
                .bold()
                .padding(.leading, 10)
            
            Text("Sleep Duration")
                .font(.subheadline)
                .bold()
                .foregroundStyle(.gray)
                .padding(.leading, 10)
            
            HStack {
                DatePicker("Bedtime", selection: $selectedStartHour, displayedComponents: .hourAndMinute)
                Text("|")
                    .foregroundStyle(.gray)
                DatePicker("Wake Up", selection: $selectedEndHour, displayedComponents: .hourAndMinute)
            }
            .padding(.leading, 10)
            
            Text("You slept for: \(sleepDuration)")
                .foregroundStyle(.blue)
                .padding(.leading, 100)
            
            Text("How many times did you wake up?")
                .font(.subheadline)
                .bold()
                .foregroundStyle(.gray)
                .padding(.leading, 10)
            
            if value < 2 {
                Text("\(value, specifier: "%.f") time")
                    .padding(.leading, 160)
                    .bold()
            } else if value < 10 {
                Text("\(value, specifier: "%.f") times")
                    .padding(.leading, 160)
                    .bold()

            } else {
                Text("\(value, specifier: "%.f")+ times")
                    .padding(.leading, 160)
                    .bold()
            }
            
            
            Slider(value: $value, in: 0...10, step: 1)
            
        
            Text("How itchy were you last night?")
                .font(.subheadline)
                .bold()
                .foregroundStyle(.gray)
                .padding(.leading, 10)
            
            VStack {
                HStack(alignment: .center, spacing: 30) {
                    ForEach(reactions , id: \.self) { reaction in
                        ZStack {
                            emojiView(selectedEmoji: $selectedEmoji, emojiText: reaction)
                                .frame(width: 50, height: 50)
                                .background(Color.white)
                                .overlay(
                                    Circle()
                                        .stroke(Color.init(red: 236/255, green: 61/255, blue: 107/255), lineWidth: selectedEmoji == reaction ? 6 : 0)
                                )
                                .cornerRadius(30)
                                .shadow(color: .gray.opacity(0.4), radius: 10, y: 10)
                                .opacity(selectedEmoji == "" || selectedEmoji == reaction ? 1 : 0.5)
                                .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 10)
                
                if selectedEmoji != "" {
                    Text(getResponseWithEmoji(selectedEmoji))
                        .font(.system(size: 17))
                        .foregroundColor(Color.pink)
                }
            }
            .onChange(of: selectedEmoji) { _, newValue in
                if !newValue.isEmpty {
                    isfilled = true
                }
            }
            
            
            HStack {
                Button{
                    save()
                    reset()
                } label: {
                    Text("Save")
                        .font(.title3)
                        .hSpacing(.center)
                        .padding(.vertical, 8)
                }
                .tint(.blue)
                .disabled(!isfilled)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 12))
            }
            
        })
        .padding()
               
    }
    func save() {
        let entry = SleepData(
            duration: sleepDuration,
            wakeups: value,
            itchlevel: getResponseWithEmoji(selectedEmoji)
        )

        modelContext.insert(entry)
        dismiss()
    }
    
    func getResponseWithEmoji(_ emoji: String) -> String {
        switch emoji {
        case "😫":
            return "Severe 😫"
        case "☹️":
            return "Moderate ☹️"
        case "🙂":
            return "Mild 🙂"
        case "😴":
            return "None 😴"
        default:
            return ""
        }
    }
    
    func reset() {
        dismiss()
        selectedStartHour = Date()
        selectedEndHour = Date()
        value = 0
    }
}

#Preview {
    SleepView()
        .modelContainer(for: SleepData.self)
}

