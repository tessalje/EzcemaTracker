//
//  9 PipView.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//
import SwiftUI

struct PipView: View {
    var body: some View {
        ZStack {
            BackgroundColor()
            Ellipse()
                .fill(.white)
                .frame(width: 550, height: 400)
                .opacity(0.6)
            
            Image("pip6")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 110)
                .offset(x: -70, y: -240)
                .rotationEffect(.degrees(-15))
            
            Image("pip")
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
                .offset(x: 4, y: -240)
            
            Image("pip2")
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
                .offset(x: 60, y: -240)
                .rotationEffect(.degrees(15))
            
            VStack {
                Text("Pip the axolotl")
                    .foregroundStyle(.pink.opacity(0.8))
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                Text(" is created by Tessa to give kids with eczema a cute companion. \nAxolotl's pink skin color and dark spots best resemble them. \nAxolotls also symbolise healing and transformation, perfect for showing Ezcemate's goal.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 21, weight: .regular, design: .rounded))
                    .frame(width: 350)
            }
            
            Image("pip5")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .offset(x: 90, y: 240)
                .rotationEffect(.degrees(-15))
            
            Image("pip4")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 140)
                .offset(x: -95, y: 230)
                .rotationEffect(.degrees(10))
            
            Image("pip3")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .offset(x: 6, y: 220)

        }
    }
}

#Preview {
    PipView()
}
