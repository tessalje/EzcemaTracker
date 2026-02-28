//
//  ContentView.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            GalleryView()
                .tabItem {
                    Image(systemName: "photo.on.rectangle.angled")
                    Text("Gallery")
                }
            
            PipView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
    }
}

struct ContentView: View {
    let images = ["pip3", "pip4", "pip5", "pip6"]
    let subtitles = ["Sleep", "Medicine","Triggers", "Games"]
    let destinations: [AnyView] = [AnyView(SleepView()), AnyView(MedicineView()), AnyView(TriggerView()), AnyView(ProgressView())]
    
    @Query var sleepEntries: [SleepData]
    var graphs: [AnyView] {
        [AnyView(SleepGraph(sleepEntries: sleepEntries)), AnyView(SleepGraph(sleepEntries: sleepEntries)), AnyView(SkinSeverityGraph())]
    }
    
    let graphName = ["Sleep quality", "Itch severity", "Idk"]
    
    @Environment(\.modelContext) private var context
    var body: some View {
        NavigationStack{
            ZStack {
                BackgroundColor()
                VStack {
                    ScrollView {
                        ZStack {
                            GlassCard(width: 360, height: 160)
                            
                            HStack {
                                VStack {
                                    Text("Meet Pip, Your Ezcemate!")
                                        .font(.system(size: 20, weight: .bold))
                                        .padding(.trailing, 40)
                                    
                                    Text("Severity: Moderate")
                                        .font(.system(size: 20, weight: .thin))
                                        .padding(.trailing, 25)
                                    
                                    NavigationLink(destination: ItchTrackerView()) {
                                        Text("Update")
                                            .foregroundStyle(.black)
                                    }
                                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 3, y: 4)
                                    .buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.capsule)
                                    .tint(.white)
                                    .padding(.trailing, 113)
                                    
                                }
                                Image("pip2")
                                    .resizable()
                                    .frame(width: 120, height: 150)
                                    .rotationEffect(.degrees(15))
                            }
                        }
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                ForEach(0..<4, id: \.self) {index in
                                    ZStack {
                                        GlassCard(width: 100, height:100)
                                        NavigationLink(destination: destinations[index]) {
                                            VStack {
                                                Image(images[index])
                                                    .resizable()
                                                    .frame(width: 80, height: 70)
                                                
                                                Text(subtitles[index])
                                                    .foregroundStyle(.black)
                                                    .font(.system(size: 15))
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Text("Daily Reminders")
                            .font(.system(size: 25, weight: .bold))
                            .padding(.top, 10)
                            .padding(.trailing, 180)
                        
                        ZStack {
                            GlassCard(width: 360, height: 120)
                            ReminderView()
                        }
                        
                        Text("Your Progress")
                            .font(.system(size: 25, weight: .bold))
                            .padding(.top, 10)
                            .padding(.trailing, 200)
                        
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<3) {index in
                                    VStack {
                                        Text(graphName[index])
                                        ZStack {
                                            GlassCard(width: 170, height:170)

                                            NavigationLink(destination: graphs[index]) {
                                                graphs[index]
                                                    .frame(width: 170, height: 170)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                }
                .navigationTitle("Ezcemate")
            }
        }
    }
}

struct GlassCard: View {
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .opacity(0.5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            .linearGradient(.init(colors: [
                                Color.red,
                                Color.clear,
                                Color.orange
                            ]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 2
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    HomeView()
}



struct BackgroundColor: View {
    let gradient = LinearGradient(colors: [Color.bg,Color.pink],startPoint: .top, endPoint: .bottom)
    

    var body: some View {
        ZStack {
            gradient
                .opacity(0.3)
                .ignoresSafeArea()

            GeometryReader { _ in
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
        }
    }
}
