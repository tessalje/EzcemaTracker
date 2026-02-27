//
//  ProgressTracker.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//


import SwiftUI
import SwiftData

struct TriggerView: View {
    @State private var isShowingSheet = false
    @Query private var triggerEntries: [TriggerData]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()
                ScrollView {
                    Text("Did you encounter any triggers recently?")
                        .padding(.trailing, 55)
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(triggerEntries) { entry in
                            TriggerItem(triggerEntry: entry)
                        }
                    }
                }
            }
            .navigationTitle("Triggers Tracker")
        }
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
            TriggerForm()
                .presentationDetents([.height(420)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
        }
    }
}
struct TriggerForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var triggerTitle: String = ""
    @State private var severity: Float = 1.0
    @State private var triggerType: TriggerType = .other
    @State private var triggerColor: TaskTint = .blue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName:"xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .hSpacing(.leading)
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Trigger")
                    .font(.caption)
                    .foregroundStyle(.gray)
                TextField("Enter item or condition", text: $triggerTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            })
            .padding(.top, 5)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Type")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Menu {
                    ForEach(TriggerType.allCases, id: \.self) { type in
                        Button(type.rawValue) {
                            triggerType = type
                        }
                    }
                } label: {
                    HStack {
                        Text(triggerType.rawValue)
                            .foregroundStyle(.black)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundStyle(.gray)
                            .font(.caption)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Severity(1-5): \(Int(severity))")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Slider(value: $severity, in: 1...5, step: 1)
            }
            .padding(.top, 5)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Color")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                HStack(spacing: 0) {
                    ForEach(TaskTint.allCases, id: \.self) { tint in
                        Circle()
                            .fill(tint.color)
                            .frame(width: 20, height: 20)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 4)
                                    .opacity(triggerColor == tint ? 1 : 0)
                            }
                            .hSpacing(.center)
                            .contentShape(.circle)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    triggerColor = tint
                                }
                            }
                    }
                }
            }
            Button(action: {
                withAnimation(.snappy) {
                    let newEntry = TriggerData(
                        triggerTitle: triggerTitle,
                        severity: Int(severity),
                        type: triggerType.rawValue,
                        tint: triggerColor
                        )
                    context.insert(newEntry)
                    print("Inserted entry: \(newEntry.triggerTitle), severity: \(newEntry.severity)")
                    dismiss()
                }
            }) {
                Text("Add Trigger")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.white)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(triggerColor.color, in: .rect(cornerRadius: 10))
            }
            .disabled(triggerTitle.isEmpty)
            .opacity(triggerTitle.isEmpty ? 0.5 : 1)
        })
        .padding(15)
    }
}


struct TriggerItem: View {
    let triggerEntry: TriggerData
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(triggerEntry.tintColor)
                .frame(width: 180, height: 180)
                .shadow(radius: 2, x: 3, y: 2)
                .blur(radius: 1.5)
            
            VStack(alignment: .leading) {
                HStack(spacing: 34) {
                    Image(systemName: TriggerType(rawValue: triggerEntry.type)?.symbol ?? "heart.fill")
                        .foregroundStyle(.black)
                        .font(.system(size: 40))
                    
                    SeverityGraphView(severity: triggerEntry.severity)
                        .frame(width: 70, height: 70)
                }
                .padding(.bottom, 10)
                
                Text(triggerEntry.triggerTitle)
                    .foregroundStyle(.black)
                    .font(.system(size: 28))
                    .bold()
                
                Text("Type: \(triggerEntry.type)")
                    .foregroundStyle(.black)
                    .font(.system(size: 18))
            }
            .padding(.leading, 5)
        }
        .contextMenu {
            Button(role: .destructive) {
                modelContext.delete(triggerEntry)
            } label: {
                Label("Delete", systemImage: "trash")
                    .foregroundStyle(.red)
            }
        }
    }
}

struct SeverityGraphView: View {
    var severity: Int
    
    private var progress: Double {
        Double(severity)/5.0
    }
    
    private var severityColor: Color {
        switch severity {
        case 1:  return .green
        case 2:  return .yellow
        case 3:  return .orange
        case 4:  return .red
        default: return .purple
        }
    }
    
    private var strokeColor: Color {
        if severity <= 2 {
            return .green
        } else if severity == 3 {
            return .yellow
        } else {
            return .red
        }
    }
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(Color.gray.opacity(0.15),lineWidth: 8)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [strokeColor.opacity(0.8),strokeColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: Color.green.opacity(0.4),radius: 10)
                .animation(.easeInOut, value: progress)
            
            VStack(spacing: 2) {
                Text("\(severity)")
                    .font(.system(size: 20, weight: .bold))
                Text("of 5")
                    .font(.caption)
                    .foregroundColor(.black)
            }
        }
        .frame(width: 60, height: 60)
        
    }
}

#Preview {
    TriggerView()
        .modelContainer(for: TriggerData.self)
}



