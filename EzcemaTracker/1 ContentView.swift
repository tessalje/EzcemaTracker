//
//  ContentView.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI

struct ContentView: View {
    let gradient = LinearGradient(colors: [Color.bg,Color.pink],startPoint: .top, endPoint: .bottom)
    var body: some View {
        NavigationStack{
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
                VStack {
                    ScrollView {
                        ZStack {
                            GlassCard(width: 360, height: 120, destination: SeverityTracker())
                                .disabled(true)
                            
                            VStack {
                                Text("Welcome back!")
                                    .font(.system(size: 20, weight: .bold))
                                    .padding(.trailing, 160)
                                
                                HStack {
                                    Text("Severity: Moderate")
                                        .font(.system(size: 20, weight: .thin))
                                        .padding(.top, 2)
                                        .padding(.trailing, 60)
                                    
                                    NavigationLink(destination: SeverityTracker()) {
                                        Text("Update")
                                            .foregroundStyle(.black)
                                    }
                                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 3, y: 4)
                                    .buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.capsule)
                                    .tint(.white)
                                    
                                }
                            }
                        }
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<4) {_ in
                                    GlassCard(width: 100, height:100,destination: GameView())
                                    
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Text("Daily Reminders")
                            .font(.system(size: 25, weight: .bold))
                            .padding(.top, 10)
                            .padding(.trailing, 180)
                        
                        GlassCard(width: 360, height: 120,destination: GameView())
                            .disabled(true)
                        
                        Text("Your Progress")
                            .font(.system(size: 25, weight: .bold))
                            .padding(.top, 10)
                            .padding(.trailing, 200)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<3) {_ in
                                    GlassCard(width: 180, height:180,destination: GameView())
                                    
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

struct GlassCard<Destination: View>: View {
    var width: CGFloat
    var height: CGFloat
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
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
}
#Preview {
    ContentView()
}
