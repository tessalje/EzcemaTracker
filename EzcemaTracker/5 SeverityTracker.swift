//
//  SeverityTracker.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI

struct SeverityTracker: View {
    
    let gradient = LinearGradient(colors: [Color.bg,Color.pink],startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        NavigationStack {
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
                    
                    VStack {
                        Text("Track your body's itch level by tapping on Pip")
                            .padding(.leading, 27)
                        Image("pip")
                            .resizable()
                            .frame(width: 330, height: 380)
                            .padding(.leading, 50)
                    }
                }
                
                Image("pip_Rhand")
                    .resizable()
                    .frame(width: 330, height: 380)
                    .offset(x: 14, y: -115)
                    .colorMultiply(.blue)
                    .contextMenu {
                        Button("Low") {
                            print("level 1")
                        }
                        Button("Medium") {
                            print("level 2")
                        }
                        Button("High") {
                            print("level 3")
                        }
                    }
                
            }
            .navigationTitle("Itch Tracker")
        }
    }
}

#Preview {
    SeverityTracker()
}
