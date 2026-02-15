//
//  3 Medicine.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//
import SwiftUI
struct Medicine: Identifiable {
    let id = UUID()
    var name: String
    var time: Date
    var dates: [Date]
}

struct MedicineView: View {
    
    let gradient = LinearGradient(colors: [Color.bg,Color.pink],startPoint: .top, endPoint: .bottom)
    @State var selectedDate = Date()
    @State private var showingSheet = false
    @State private var medicines: [Medicine]
    
    var body: some View {
        VStack {
            ZStack {
                gradient
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                GeometryReader{ proxy in
                    Color.white
                        .opacity(0.3)
                        .blur(radius: 200)
                        .ignoresSafeArea()
                    
                    Circle()
                        .fill(Color.pink)
                        .padding(50)
                        .blur(radius: 120)
                        .offset(x: -200, y: -60)
                    
                    Circle()
                        .fill(Color.orange)
                        .padding(50)
                        .blur(radius: 120)
                        .offset(x: 240, y: 450)
                }
                ScrollView {
                    DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                    
                    Button("Create", systemImage: "plus") {
                        showingSheet.toggle()
                    }
                    .padding(.leading, 200)
                    .foregroundStyle(.black)
                    .sheet(isPresented: $showingSheet) {
                        EditMedicine(medicine: .constant(nil)) { index in
                            medicines.append(index)
                        }
                    }
                    
                    ForEach($medicines) { $med in
                        if med.dates.contains(where: {
                            Calendar.current.isDate($0, inSameDayAs: selectedDate)
                        }) {
                            MedicineCard(
                                medicine: $med,
                                onDelete: {
                                    medicines.removeAll { $0.id == med.id }
                                }
                            )
                        }
                    }
                }
                
            }
        }
    }
}

struct MedicineCard: View {
    
    @Binding var medicine: Medicine
    var onDelete: () -> Void
    @State private var showingSheet = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 300, height: 100)
            
            VStack {
                HStack {
                    Image(systemName: "pill")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                    
                    Text(medicine.name)
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                    
                    Button("", systemImage: "pencil") {
                        showingSheet.toggle()
                    }
                    .font(.system(size: 30))
                    .padding(.leading, 100)
                    .foregroundStyle(.black)
                    .sheet(isPresented: $showingSheet) {
                        EditMedicine(medicine: Binding<Medicine?>(
                            get: { medicine },
                            set: { if let newValue = $0 { medicine = newValue } }
                        ), onSave: nil)
                    }
                    
                    Button("Delete", role: .destructive) {
                        onDelete()
                    }
                    Button("Cancel", role: .cancel) {}
                }
                Text(medicine.time.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                    .padding(.trailing, 150)
            }
            
        }
        
    }
}


struct EditMedicine: View {
    @Environment(\.dismiss) var dismiss
    @Binding var medicine: Medicine?
    
    var onSave: ((Medicine) -> Void)?
    
    @State private var medicineName = ""
    @State private var time = Date()
    @State private var selectedDates: Set<DateComponents> = []
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View {
        TextField("Enter medicine to be taken", text: $medicineName)
            .textFieldStyle(.roundedBorder)
            .padding()
        
        DatePicker("Select time",
                   selection: $time,
                   displayedComponents: .hourAndMinute)
        
        MultiDatePicker("Select dates",
                        selection: $selectedDates)
        
        Button("Save") {
            let dates = selectedDates.compactMap {
                Calendar.current.date(from: $0)
            }
            
            let newMedicine = Medicine(
                name: medicineName,
                time: time,
                dates: dates)
            
            onSave!(newMedicine)
            dismiss()
        }
    }
}

