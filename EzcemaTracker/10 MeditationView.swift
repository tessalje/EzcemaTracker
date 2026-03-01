//
//  10 MeditationView.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 1/3/26.
//
import SwiftUI


struct StartMeditationView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()
                VStack {
                    Text("Feeling itchy?")
                        .foregroundStyle(.pink)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                    
                    Text("Click Start")
                        .foregroundStyle(.pink)
                        .font(.system(size: 20, design: .monospaced))
                    
                    Image("pip")
                        .resizable()
                        .frame(width: 450, height: 400)
                    
                    NavigationLink(destination: Meditation()) {
                        Text("▶ Start")
                            .font(.title2)
                    }
                    .tint(.pink)
                    .buttonStyle(.bordered)
                    .padding(20)
                }
            }
            
        }
    }
}

struct Meditation: View {
    @State var animate = false
    @State private var phaseIndex = 0
    let phases = ["Inhale", "Hold", "Exhale", "Hold"]
    
    let text = ["Breathe", "Where do you feel it?", "Rate the itch from 1-10", "You are in control"]
    
    @State private var secondsRemaining = 4
        @State private var timer: Timer?
    
    let phaseDuration = 4.0

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()
                
                VStack{
                    Text(text[phaseIndex])
                        .font(.title3)
                        .foregroundStyle(.white)
                        .foregroundColor(.white.opacity(0.8))
                        .animation(.bouncy, value: secondsRemaining)
                    
                    Text("\(secondsRemaining)")
                        .font(.title)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .animation(.default, value: secondsRemaining)
                    
                    ZStack {
                        Circle()
                            .fill(Color.pink.opacity(0.25))
                            .frame(width: 358, height: 358)
                            .scaleEffect(animate ? 1 : 0)
                        Circle()
                            .fill(Color.pink.opacity(0.35))
                            .frame(width: 250, height: 250)
                            .scaleEffect(animate ? 1 : 0)
                        Circle()
                            .fill(Color.pink.opacity(0.45))
                            .frame(width: 158, height: 150)
                            .scaleEffect(animate ? 1 : 0)
                        
                        Circle()
                            .fill(Color.pink)
                            .frame(width: 38, height: 38)
                        
                        Text(phases[phaseIndex])
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .animation(.bouncy, value: secondsRemaining)
                    }
                    
                    NavigationLink(destination: HomeView()) {
                        Text("■ Stop")
                            .font(.title2)
                    }
                    .tint(.pink)
                    .buttonStyle(.bordered)
                    .padding(20)
                }
            }
            .onAppear {
                startBreathingCycle()
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
            }
            .animation(.easeInOut(duration: phaseDuration), value: animate)
        }
        .navigationBarBackButtonHidden()
    }
    func startTimer() {
        timer?.invalidate()
        secondsRemaining = Int(phaseDuration)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if secondsRemaining > 1 {
                secondsRemaining -= 1
            } else {
                secondsRemaining = Int(phaseDuration)
            }
        }
    }
    
    
    func startBreathingCycle() {
        phaseIndex = 0
        animate = true

        DispatchQueue.main.asyncAfter(deadline: .now() + phaseDuration) {
            phaseIndex = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + phaseDuration * 2) {
            phaseIndex = 2
            animate = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + phaseDuration * 3) {
            phaseIndex = 3
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + phaseDuration * 4) {
            startBreathingCycle()
        }
    }
}


#Preview {
    StartMeditationView()
}
