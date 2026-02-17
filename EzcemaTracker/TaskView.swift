//
//  TaskView.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 15/2/26.
//
import SwiftUI
import SwiftData

struct TaskRowView: View {
    @Bindable var task: TrackerTask
    @Environment(\.modelContext) private var context
    var body: some View {
        
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color:.black.opacity(0.1), radius: 3)), in: .circle)
                .overlay {
                    Circle()
                        .frame(width: 50, height: 50)
                        .blendMode(.destinationOver)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()
                            }
                        }
                }
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text(task.taskTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                
                Label(task.creationDate.format("hh:mm a"), systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.black)
            })
            .padding(15)
            .hSpacing(.leading)
            .background(task.tintColor, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .strikethrough(task.isCompleted, pattern: .solid, color: .black)
            .offset(y:-8)
            .contextMenu {
                Button(role: .destructive) {
                    context.delete(task)
                    try? context.save()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
    
    var indicatorColor: Color {
        if task.isCompleted{
            return .green
        }
        
        return .red
    }
    
}

struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var taskTitle: String = ""
    @State private var taskColor: TaskTint = .blue
    
    @Binding var currentDate: Date
    @State private var taskDate: Date
    init(currentDate: Binding<Date>) {
        self._currentDate = currentDate
        self._taskDate = State(initialValue: currentDate.wrappedValue)
    }
    
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
                Text("Medicine Name")
                    .font(.caption)
                    .foregroundStyle(.gray)
                TextField("Enter name", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            })
            .padding(.top, 5)
            
            HStack {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Medicine Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                })
                .padding(.top, 5)
                .padding(.trailing, -15)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Medicine Color")
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
                                        .opacity(taskColor == tint ? 1 : 0)
                                }
                                .hSpacing(.center)
                                .contentShape(.circle)
                                .onTapGesture {
                                    withAnimation(.snappy) {
                                        taskColor = tint
                                    }
                                }
                        }
                    }
                }
            }
            
            Button(action: {
                withAnimation(.snappy) {
                    let task = TrackerTask(taskTitle: taskTitle, creationDate: taskDate, tint: taskColor)
                    do {
                        context.insert(task)
                        try context.save()
                        currentDate = taskDate
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                }
            }, label: {
                Text("Add Medicine")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.white)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(taskColor.color, in: .rect(cornerRadius: 10))
            })
            .disabled(taskTitle == "")
            .opacity(taskTitle == "" ? 0.5 : 1)
        })
        .padding(15)
    }
}

struct TaskView: View {
    @Binding var currentDate: Date
    
    @Query private var tasks: [TrackerTask]
    init(currentDate: Binding<Date>) {
        self._currentDate = currentDate
        
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: currentDate.wrappedValue)
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startOfDate)!
        let predicate = #Predicate<TrackerTask> {
            return $0.creationDate >= startOfDate && $0.creationDate < endOfDate
        }
        
        
        let sortDescriptor = [
            SortDescriptor(\TrackerTask.creationDate, order: .forward)
        ]
        self._tasks = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            ForEach(tasks) { task in
                TaskRowView(task: task)
                    .background(alignment: .leading) {
                        if tasks.last?.id != task.id {
                            Rectangle()
                                .frame(width: 1)
                                .offset(x: 8)
                                .padding(.bottom, -35)
                        }
                    }
            }
        }
        .padding([.vertical, .leading], 15)
        .padding(.top, 15)
        .overlay {
            if tasks.isEmpty {
                Text("No Medicine Saved")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(width: 150)
            }
        }
    }
}

#Preview {
    MedicineView()
}
