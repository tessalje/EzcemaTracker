//
//  3 Medicine.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//
import SwiftUI

struct MedicineView: View {
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    
    @State private var createWeek: Bool = false
    @State private var createNewTask: Bool = false
    
    @Namespace private var animation
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundColor()
                
                VStack(alignment: .leading, spacing: 6, content: {
                    HeaderView()
                    
                    ScrollView(.vertical) {
                        VStack {
                            TaskView(currentDate: $currentDate)
                        }
                        .hSpacing(.center)
                        .vSpacing(.center)
                    }
                    .scrollIndicators(.hidden)
                })
                .vSpacing(.top)
                .overlay(alignment: .bottomTrailing, content: {
                    Button(action: {
                        createNewTask.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 55, height: 55)
                            .background(.blue.shadow(.drop(color: .black.opacity(0.4), radius:5, x: 2, y: 4)), in: .circle)
                    })
                })
                .padding(15)
                .onAppear(perform: {
                    if weekSlider.isEmpty {
                        let currentWeek = Date().fetchWeek()
                        
                        if let firstDate =  currentWeek.first?.date {
                            weekSlider.append(firstDate.createPreviousWeek())
                        }
                        
                        weekSlider.append(currentWeek)
                        
                        if let lastDate =  currentWeek.last?.date {
                            weekSlider.append(lastDate.createNextWeek())
                        }
                    }
                })
                .sheet(isPresented: $createNewTask) {
                    NewTaskView(currentDate: $currentDate)
                        .presentationDetents([.height(300)])
                        .interactiveDismissDisabled()
                        .presentationCornerRadius(30)
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Text(currentDate.format("MMM"))
                    .foregroundStyle(.blue)
                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.white)
            }
            .font(.title.bold())
            
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
                .foregroundStyle(.white)
            
            
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        }
        .padding(15)
        .hSpacing(.leading)
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == weekSlider.count - 1 {
                createWeek = true
            }
        }
    }
    
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.black)
                    
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white: .black)
                        .frame(width: 35, height: 35)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(.blue)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            
                            if day.date.isToday {
                                Circle()
                                    .fill(.cyan)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 11)
                            }
                        })
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                }
            }
        }
    }
    
    func paginateWeek() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPreviousWeek(), at:0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
}

#Preview {
    MedicineView()
}

