//
//  SeverityTracker.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI

struct ItchTrackerView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()
                
                VStack {
                    Text("Track your body's itch level by tapping on Pip")
                        .padding(.leading, 27)
                    Image("pip")
                        .resizable()
                        .frame(width: 330, height: 380)
                        .padding(.leading, 50)
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
    ItchTrackerView()
}
