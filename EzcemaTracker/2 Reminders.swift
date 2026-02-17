//
//  Reminders.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI
internal import Combine

struct ReminderView: View {
    @State private var quote = "Flare-ups are not your fault."
    @State private var quotebg: Int = 1
    
    let quotes = [
        "Flare-ups are not your fault.",
        "It does not matter how slowly you go as long as you do not stop.",
        "YOU CAN DO THIS!",
        "Your not alone.",
        "Take as much time as you need to care for yourself.",
        "Be gentle with your skin today.",
        "Healing takes time. You are improving.",
        "Press, don’t scratch.",
        "Pip believes in you!",
        "Remember to moisturise within 3 minutes after shower",
        "Use gentle, fragrance-free cleanser",
        "Trim nails to prevent damage",
        "Wear cotton to protect your skin",
        "Reapply cream on your hands after washing",
        "Try a cold cloth/ice pack to cool your skin",
        "Apply moisturiser instead of scratching",
        "Take 3 slow breaths before reacting",
        "Focus on hand care today",
        "You’re improving — keep going!",
        "Sending you a big hug and wishing you a speedy recovery!",
        "Hoping each day brings you closer to recovery",
        "Rest up and take all the time you need to heal",
        "Remember: Health is your top priority",
        "Better days are ahead",
        "Take your medication!",
        "Keep showers under 10-15 minutes with lukewarm water",
        "Gently pat skin dry with a towel instead of rubbing",
        "Use a humidifier to prevent dry air",
        "Consult a doctor if skin becomes infected",
        "Stay calm! High stress can trigger flares",
        "Apply thick creams or ointments",
        "Once you replace negative thoughts with positive ones, you'll start having positive results",
        "Take care of your body. It's the only place you have to live.",
        "Let food be thy medicine and medicine be thy food.",
        "Early to bed and early to rise makes a man healthy, wealthy, and wise.",
        "Breathe. Let go.",
        "Dream as if you'll live forever.",
    ]

    @State private var timer = Timer.publish(every:300, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Image("quotebg\(quotebg)")
                .resizable()
                .scaledToFill()
                .opacity(0.7)
                .frame(width: 360, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            RoundedRectangle(cornerRadius: 20)
                .fill(.black)
                .opacity(0.3)
                .frame(width: 360, height: 120)
            
            Text(quote)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .shadow(radius: 3)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .frame(width: 340, height: 120)
            
        }
        .onReceive(timer) { _ in
            refreshQuote()
        }
    }
    
    func refreshQuote() {
        quote = quotes.randomElement() ?? ""
        quotebg = Int.random(in: 1...14)
    }
}

#Preview {
    ReminderView()
}
